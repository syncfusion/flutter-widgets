package com.syncfusion.flutter.pdfviewer;

import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.Rect;
import android.graphics.pdf.PdfRenderer;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.os.ParcelFileDescriptor;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * SyncfusionFlutterPdfViewerPlugin
 */
public class SyncfusionFlutterPdfViewerPlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    /// Pdf result.
    private Result resultPdf;
    /// Document repository.
    Map<String, PdfFileRenderer> documentRepo = new HashMap<>();

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "syncfusion_flutter_pdfviewer");
        channel.setMethodCallHandler(this);
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    @SuppressWarnings("deprecation")
    public static void registerWith(io.flutter.plugin.common.PluginRegistry.Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "syncfusion_flutter_pdfviewer");
        channel.setMethodCallHandler(new SyncfusionFlutterPdfViewerPlugin());
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    @Override
    public void onMethodCall(@NonNull final MethodCall call, @NonNull final Result result) {
        resultPdf = result;
        switch (call.method) {
            case "getImage":
                getImage(Integer.parseInt(Objects.requireNonNull(call.argument("index")).toString()),
                        Double.parseDouble(Objects.requireNonNull(call.argument("scale")).toString()),
                        (String) call.argument("documentID"));
                break;
            case "initializePdfRenderer":
                result.success(initializePdfRenderer((byte[]) call.argument("documentBytes"),
                        (String) call.argument("documentID")));
                break;
            case "getPagesWidth":
                result.success(getPagesWidth((String) call.arguments));
                break;
            case "getPagesHeight":
                result.success(getPagesHeight((String) call.arguments));
                break;
            case "closeDocument":
                result.success(closeDocument((String) call.arguments));
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }


    // Initializes the PDF Renderer and returns the page count.
    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    String initializePdfRenderer(byte[] path, String documentID) {
        try {
            File file = File.createTempFile(
                    ".syncfusion", ".pdf"
            );
            OutputStream stream = new FileOutputStream(file);
            stream.write(path);
            stream.close();
            ParcelFileDescriptor fileDescriptor = ParcelFileDescriptor.open(file, ParcelFileDescriptor.MODE_READ_ONLY);
            PdfRenderer renderer = new PdfRenderer(fileDescriptor);
            PdfFileRenderer fileRenderer = new PdfFileRenderer(fileDescriptor, renderer);
            documentRepo.put(documentID, fileRenderer);
            int pageCount = renderer.getPageCount();
            return String.valueOf(pageCount);
        } catch (Exception e) {
            return e.toString();
        }
    }

    // Returns the height collection of rendered pages.
    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    double[] getPagesHeight(String documentID) {
        try {
            int count = Objects.requireNonNull(documentRepo.get(documentID)).renderer.getPageCount();
            double[] pageHeight = new double[count];
            for (int i = 0; i < count; i++) {
                PdfRenderer.Page page = Objects.requireNonNull(documentRepo.get(documentID)).renderer.openPage(i);
                pageHeight[i] = page.getHeight();
                page.close();
            }
            return pageHeight;
        } catch (Exception e) {
            return null;
        }
    }

    // Returns the width collection of rendered pages.
    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    double[] getPagesWidth(String documentID) {
        try {
            int count = Objects.requireNonNull(documentRepo.get(documentID)).renderer.getPageCount();
            double[] pageWidth = new double[count];
            for (int i = 0; i < count; i++) {
                PdfRenderer.Page page = Objects.requireNonNull(documentRepo.get(documentID)).renderer.openPage(i);
                pageWidth[i] = page.getWidth();
                page.close();
            }
            return pageWidth;
        } catch (Exception e) {
            return null;
        }
    }

    // Gets the specific page from PdfRenderer
    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    void getImage(int pageIndex, double scale, String documentID) {
        try {
            ExecutorService executor = Executors.newCachedThreadPool();
            Runnable bitmapRunnable = new PdfRunnable(Objects.requireNonNull(documentRepo.get(documentID)).renderer, resultPdf, pageIndex, scale);
            executor.submit(bitmapRunnable);
        } catch (Exception e) {
            resultPdf.error(e.getMessage(), e.getLocalizedMessage(), e.getMessage());
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    boolean closeDocument(String documentID) {
        try {
            Objects.requireNonNull(documentRepo.get(documentID)).renderer.close();
            Objects.requireNonNull(documentRepo.get(documentID)).fileDescriptor.close();
            documentRepo.remove(documentID);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return true;
    }
}

/// Represents class which holds PdfRenderer and FileDescriptor.
class PdfFileRenderer {
    public PdfRenderer renderer;
    public ParcelFileDescriptor fileDescriptor;

    PdfFileRenderer(ParcelFileDescriptor fileDescriptor, PdfRenderer renderer) {
        this.renderer = renderer;
        this.fileDescriptor = fileDescriptor;
    }
}

/// This runnable executes all the image fetch in separate thread.
class PdfRunnable implements Runnable {
    private byte[] imageBytes = null;
    final private PdfRenderer renderer;
    final private Result resultPdf;
    final private int pageIndex;
    private double scale;
    private PdfRenderer.Page page;

    PdfRunnable(PdfRenderer renderer, Result resultPdf, int pageIndex, double scale) {
        this.resultPdf = resultPdf;
        this.renderer = renderer;
        this.pageIndex = pageIndex;
        this.scale = scale;
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    public void dispose() {
        imageBytes = null;
        if (page != null) {
            page.close();
            page = null;
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    public void run() {
        page = renderer.openPage(pageIndex - 1);
        if (scale < 1.75) {
            scale = 1.75;
        }
        int width = (int) (page.getWidth() * scale);
        int height = (int) (page.getHeight() * scale);
        final Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
        bitmap.eraseColor(Color.WHITE);
        final Rect rect = new Rect(0, 0, width, height);
        page.render(bitmap, rect, null, PdfRenderer.Page.RENDER_MODE_FOR_DISPLAY);
        page.close();
        page = null;
        ByteArrayOutputStream outStream = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, outStream);

        imageBytes = outStream.toByteArray();
        synchronized (this) {
            notifyAll();
        }
        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                resultPdf.success(imageBytes);
            }
        });
    }
}