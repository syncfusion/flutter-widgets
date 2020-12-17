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
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** SyncfusionFlutterPdfViewerPlugin */
public class SyncfusionFlutterPdfViewerPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  /// Width collections of rendered pages
  private double[] pageWidth;
  /// Height collections of rendered pages
  private double[] pageHeight;
  /// Number of pages in the PDF
  private int pageCount;
  private Result resultPdf;
  /// PdfRenderer instance
  private PdfRenderer renderer;
  /// Initial File descriptor
  ParcelFileDescriptor fileDescriptor;
  /// PDF document path.
  String pdfPath;
  /// PDF Runnable
  PdfRunnable bitmapRunnable;
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
    if (call.method.equals("getimage")) {
      getImage((int) call.argument("index"), (String) call.argument("path"));
    } else if (call.method.equals("initializepdfrenderer")) {
      result.success(initializePdfRenderer((String) call.arguments));
    } else if (call.method.equals("getpageswidth")) {
      result.success(getPagesWidth((String) call.arguments));
    } else if (call.method.equals("getpagesheight")) {
      result.success(getPagesHeight((String) call.arguments));
    } else if (call.method.equals("dispose")) {
      result.success(dispose());
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }


  // Initializes the PDF Renderer and returns the page count.
  @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
  String initializePdfRenderer(String path) {
    File file = new File(path);
    try {
      fileDescriptor = ParcelFileDescriptor.open(file, ParcelFileDescriptor.MODE_READ_ONLY);
      renderer = new PdfRenderer(fileDescriptor);
      pageCount = renderer.getPageCount();
      pdfPath = path;
      return String.valueOf(pageCount);
    } catch (Exception e) {
      return e.toString();
    }
  }

  @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
  void reinitializePdfRenderer(String path) throws IOException {
    if (pdfPath == null || pdfPath.compareTo(path) != 0)
      try {
        File file = new File(path);
        ParcelFileDescriptor fileDescriptor = ParcelFileDescriptor.open(file, ParcelFileDescriptor.MODE_READ_ONLY);
        renderer = new PdfRenderer(fileDescriptor);
        pageCount = renderer.getPageCount();
        pdfPath = path;
        pageHeight = null;
        pageWidth = null;
      } catch (Exception e) {
        throw e;
      }
  }

  // Returns the height collection of rendered pages.
  @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
  double[] getPagesHeight(String path) {
    try {
      reinitializePdfRenderer(path);
      pageHeight = new double[pageCount];
      pageWidth = new double[pageCount];
      for (int i = 0; i < pageCount; i++) {
        PdfRenderer.Page page = renderer.openPage(i);
        pageHeight[i] = page.getHeight();
        pageWidth[i] = page.getWidth();
        page.close();
      }
      return pageHeight;
    } catch (Exception e) {
      return null;
    }
  }

  // Returns the width collection of rendered pages.
  @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
  double[] getPagesWidth(String path) {
    try {
      reinitializePdfRenderer(path);
      if (pageWidth == null) {
        int count = renderer.getPageCount();
        pageWidth = new double[count];
        for (int i = 0; i < count; i++) {
          PdfRenderer.Page page = renderer.openPage(i);
          pageWidth[i] = page.getWidth();
          page.close();
        }
      }
      return pageWidth;
    } catch (Exception e) {
      return null;
    }
  }

  // Gets the specific page from PdfRenderer
  @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
  void getImage(int pageIndex, String path) {
    try {
      reinitializePdfRenderer(path);
      ExecutorService executor = Executors.newCachedThreadPool();
      bitmapRunnable = new PdfRunnable(renderer, resultPdf, pageIndex);
      executor.submit(bitmapRunnable);
    } catch (Exception e) {
      resultPdf.error(e.getMessage(), e.getLocalizedMessage(), e.getMessage());
    }
  }

  @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
  boolean dispose() {
    if (pageWidth != null)
      pageWidth = null;
    if (pageHeight != null)
      pageHeight = null;
    if (renderer != null) {
      bitmapRunnable.dispose();
      renderer.close();
      renderer = null;
    }
    pdfPath = null;
    if (fileDescriptor != null) {
      try {
        fileDescriptor.close();
      } catch (IOException e) {
        return false;
      }
    }
    return true;
  }
}

/// This runnable executes all the image fetch in separate thread.
class PdfRunnable implements Runnable
{
    private List<byte[]> bitmaps = null;
    private PdfRenderer renderer;
    private Result resultPdf;
    private int pageIndex;
    private PdfRenderer.Page page;

    PdfRunnable(PdfRenderer renderer, Result resultPdf,  int pageIndex) {
      this.resultPdf = resultPdf;
      this.renderer = renderer;
      this.pageIndex = pageIndex;
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    public void dispose()
    {
      bitmaps = null;
      if(page != null)
      {
        page.close();
        page = null;
      }
    }

  @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
  public void run() {
      page = renderer.openPage(pageIndex - 1);
      int width = (int) (page.getWidth() * 1.75);
      int height = (int) (page.getHeight() * 1.75);
      final Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
      bitmap.eraseColor(Color.WHITE);
      final Rect rect = new Rect(0, 0, width, height);
      page.render(bitmap, rect, null, PdfRenderer.Page.RENDER_MODE_FOR_DISPLAY);
      page.close();
      page = null;
      ByteArrayOutputStream outStream = new ByteArrayOutputStream();
      bitmap.compress(Bitmap.CompressFormat.PNG, 100, outStream);
      bitmaps = new ArrayList<>();
      bitmaps.add(outStream.toByteArray());
      synchronized (this) {
        notifyAll();
      }
      new Handler(Looper.getMainLooper()).post(new Runnable() {
        @Override
        public void run() {
          resultPdf.success(bitmaps);
        }
      });
    }
}