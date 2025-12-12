package com.syncfusion.flutter.pdfviewer;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.Rect;
import android.graphics.pdf.PdfRenderer;
import android.os.Build;
import android.os.ParcelFileDescriptor;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.ByteBuffer;
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

import java.lang.reflect.Constructor;
import java.lang.reflect.Method;

@RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
public class SyncfusionFlutterPdfViewerPlugin implements FlutterPlugin, MethodCallHandler {
    private MethodChannel channel;
    private Context context;
    private Map<String, PdfFileRenderer> documentRepo = new HashMap<>();
    private ExecutorService executorService;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "syncfusion_flutter_pdfviewer");
        channel.setMethodCallHandler(this);
        context = flutterPluginBinding.getApplicationContext();
        executorService = Executors.newFixedThreadPool(Runtime.getRuntime().availableProcessors());
    }

    @Override
    public void onMethodCall(@NonNull final MethodCall call, @NonNull final Result result) {
        switch (call.method) {
            case "getPage":
                getPage(call, result);
                break;
            case "getTileImage":
                getTileImage(call, result);
                break;
            case "initializePdfRenderer":
                initializePdfRenderer(call, result);
                break;
            case "getPagesWidth":
                getPagesWidth(call, result);
                break;
            case "getPagesHeight":
                getPagesHeight(call, result);
                break;
            case "closeDocument":
                closeDocument(call, result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        executorService.shutdown();
    }

    private void getPage(MethodCall call, Result result) {
        int pageIndex = call.argument("index");
        int width = call.argument("width");
        int height = call.argument("height");
        String documentID = call.argument("documentID");
        try {
            PdfRenderer.Page page = Objects.requireNonNull(documentRepo.get(documentID)).renderer.openPage(pageIndex - 1);
            final Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
            bitmap.eraseColor(Color.WHITE);
            final Rect rect = new Rect(0, 0, width, height);
            page.render(bitmap, rect, null, PdfRenderer.Page.RENDER_MODE_FOR_DISPLAY);
            page.close();
            ByteBuffer buffer = ByteBuffer.allocate(bitmap.getByteCount());
            bitmap.copyPixelsToBuffer(buffer);
            bitmap.recycle();
            final byte[] imageBytes = buffer.array();
            buffer.clear();
            result.success(imageBytes);
        } catch (Exception e) {
            result.error(e.getMessage(), e.getLocalizedMessage(), e.getMessage());
        }
    }

    private void getTileImage(MethodCall call, Result result) {
        int pageNumber = call.argument("pageNumber");
        double scale = call.argument("scale");
        double x = call.argument("x");
        double y = call.argument("y");
        double width = call.argument("width");
        double height = call.argument("height");
        String documentID = call.argument("documentID");
        try {
            PdfRenderer.Page page = Objects.requireNonNull(documentRepo.get(documentID)).renderer.openPage(pageNumber - 1);
            final Bitmap bitmap = Bitmap.createBitmap((int) width, (int) height, Bitmap.Config.ARGB_8888);
            bitmap.eraseColor(Color.WHITE);
            Matrix matrix = new Matrix();
            matrix.postTranslate((float) -x, (float) -y);
            matrix.postScale((float) (scale), (float) (scale));
            final Rect rect = new Rect(0, 0, (int) width, (int) height);
            page.render(bitmap, rect, matrix, PdfRenderer.Page.RENDER_MODE_FOR_DISPLAY);
            page.close();
            ByteBuffer buffer = ByteBuffer.allocate(bitmap.getByteCount());
            bitmap.copyPixelsToBuffer(buffer);
            bitmap.recycle();
            final byte[] imageBytes = buffer.array();
            buffer.clear();
            result.success(imageBytes);
        } catch (Exception e) {
            result.error(e.getMessage(), e.getLocalizedMessage(), e.getMessage());
        }
    }

    private void initializePdfRenderer(MethodCall call, Result result) {
        executorService.execute(() -> {
            byte[] bytes = call.argument("documentBytes");
            String documentID = call.argument("documentID");
            String password = call.argument("password");

            try {
                File file = File.createTempFile(".syncfusion", ".pdf", context.getCacheDir());
                try (FileOutputStream stream = new FileOutputStream(file)) {
                    stream.write(bytes);
                }

                ParcelFileDescriptor fileDescriptor = ParcelFileDescriptor.open(file, ParcelFileDescriptor.MODE_READ_ONLY);

                PdfRenderer renderer;

                if (Build.VERSION.SDK_INT >= 35 && password != null) {
                    renderer = createPdfRendererWithPassword(fileDescriptor, password);
                } else {
                    renderer = new PdfRenderer(fileDescriptor);
                }

                PdfFileRenderer fileRenderer = new PdfFileRenderer(fileDescriptor, renderer);
                documentRepo.put(documentID, fileRenderer);
                int pageCount = renderer.getPageCount();
                file.delete();
                result.success(String.valueOf(pageCount));
            } catch (SecurityException e) {
                result.error("PASSWORD_ERROR", "Incorrect password or document is encrypted", null);
            } catch (Exception e) {
                result.error("PDF_RENDERER_ERROR", e.getMessage(), null);
            }
        });
    }

    private PdfRenderer createPdfRendererWithPassword(ParcelFileDescriptor fileDescriptor, String password) throws Exception {
        Class<?> loadParamsBuilderClass = Class.forName("android.graphics.pdf.LoadParams$Builder");
        Constructor<?> builderConstructor = loadParamsBuilderClass.getDeclaredConstructor();
        Object builder = builderConstructor.newInstance();

        Method setPasswordMethod = loadParamsBuilderClass.getMethod("setPassword", String.class);
        setPasswordMethod.invoke(builder, password);

        Method buildMethod = loadParamsBuilderClass.getMethod("build");
        Object loadParams = buildMethod.invoke(builder);

        Class<?> pdfRendererClass = PdfRenderer.class;
        Constructor<?> pdfRendererConstructor = pdfRendererClass.getDeclaredConstructor(ParcelFileDescriptor.class, loadParams.getClass());
        return (PdfRenderer) pdfRendererConstructor.newInstance(fileDescriptor, loadParams);
    }

    private void getPagesWidth(MethodCall call, Result result) {
        String documentID = (String) call.arguments;
        PdfFileRenderer fileRenderer = documentRepo.get(documentID);
        if (fileRenderer == null) {
            result.error("DOCUMENT_NOT_FOUND", "Document with ID " + documentID + " not found", null);
            return;
        }
        executorService.execute(() -> {
            try {
                int count = fileRenderer.renderer.getPageCount();
                double[] pageWidth = new double[count];
                for (int i = 0; i < count; i++) {
                    try (PdfRenderer.Page page = fileRenderer.renderer.openPage(i)) {
                        pageWidth[i] = page.getWidth();
                    }
                }
                result.success(pageWidth);
            } catch (Exception e) {
                result.error("PAGE_WIDTH_ERROR", e.getMessage(), null);
            }
        });
    }

    private void getPagesHeight(MethodCall call, Result result) {
        String documentID = (String) call.arguments;
        PdfFileRenderer fileRenderer = documentRepo.get(documentID);
        if (fileRenderer == null) {
            result.error("DOCUMENT_NOT_FOUND", "Document with ID " + documentID + " not found", null);
            return;
        }
        executorService.execute(() -> {
            try {
                int count = fileRenderer.renderer.getPageCount();
                double[] pageHeight = new double[count];
                for (int i = 0; i < count; i++) {
                    try (PdfRenderer.Page page = fileRenderer.renderer.openPage(i)) {
                        pageHeight[i] = page.getHeight();
                    }
                }
                result.success(pageHeight);
            } catch (Exception e) {
                result.error("PAGE_HEIGHT_ERROR", e.getMessage(), null);
            }
        });
    }

    private void closeDocument(MethodCall call, Result result) {
        String documentID = (String) call.arguments;
        PdfFileRenderer fileRenderer = documentRepo.remove(documentID);
        if (fileRenderer != null) {
            try {
                fileRenderer.renderer.close();
                fileRenderer.fileDescriptor.close();
                result.success(true);
            } catch (IOException e) {
                result.error("CLOSE_ERROR", e.getMessage(), null);
            }
        } else {
            result.success(false);
        }
    }
}

class PdfFileRenderer {
    public PdfRenderer renderer;
    public ParcelFileDescriptor fileDescriptor;

    PdfFileRenderer(ParcelFileDescriptor fileDescriptor, PdfRenderer renderer) {
        this.renderer = renderer;
        this.fileDescriptor = fileDescriptor;
    }
}