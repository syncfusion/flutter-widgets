package com.syncfusion.flutter.pdfviewer;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.Rect;
import android.graphics.pdf.PdfRenderer;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.os.ParcelFileDescriptor;
import android.util.DisplayMetrics;
import android.view.Display;
import android.view.WindowManager;

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
import java.nio.ByteBuffer;
import java.lang.Math;

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
  double viewportWidth;
  private Context context;
  /// Width collections of rendered pages
  private double[] pageWidth;
  /// Height collections of rendered pages
  private double[] pageHeight;
  /// Document repository.
  Map<String, PdfFileRenderer> documentRepo = new HashMap<>();

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "syncfusion_flutter_pdfviewer");
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.getApplicationContext();
  }

  @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
  @Override
  public void onMethodCall(@NonNull final MethodCall call, @NonNull final Result result) {
    resultPdf = result;
    switch (call.method) {
      case "getPage":
        getPage(
          Integer.parseInt(Objects.requireNonNull(call.argument("index")).toString()),
          Integer.parseInt(Objects.requireNonNull(call.argument("width")).toString()),
          Integer.parseInt(Objects.requireNonNull(call.argument("height")).toString()),
          (String) call.argument("documentID"));
        break;
      case "getTileImage":
        getTileImage(Integer.parseInt(Objects.requireNonNull(call.argument("pageNumber")).toString()),
            Double.parseDouble(Objects.requireNonNull(call.argument("scale")).toString()),
            Double.parseDouble(Objects.requireNonNull(call.argument("x")).toString()),
            Double.parseDouble(Objects.requireNonNull(call.argument("y")).toString()),
            Double.parseDouble(Objects.requireNonNull(call.argument("width")).toString()),
            Double.parseDouble(Objects.requireNonNull(call.argument("height")).toString()),
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
      file.delete();
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
      pageHeight = new double[count];
      pageWidth = new double[count];
      for (int i = 0; i < count; i++) {
        PdfRenderer.Page page = Objects.requireNonNull(documentRepo.get(documentID)).renderer.openPage(i);
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
  double[] getPagesWidth(String documentID) {
    try {
      if (pageWidth == null) {
          int count = Objects.requireNonNull(documentRepo.get(documentID)).renderer.getPageCount();
          pageWidth = new double[count];
          for (int i = 0; i < count; i++) {
            PdfRenderer.Page page = Objects.requireNonNull(documentRepo.get(documentID)).renderer.openPage(i);
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
  void getPage(int pageIndex, int width, int height, String documentID) {
    try {
      PdfRenderer.Page page = Objects.requireNonNull(documentRepo.get(documentID)).renderer.openPage(pageIndex - 1);
      double scale = Math.min(width / pageWidth[pageIndex - 1], height / pageHeight[pageIndex - 1]);
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
      resultPdf.success(imageBytes);
    } catch (Exception e) {
      resultPdf.error(e.getMessage(), e.getLocalizedMessage(), e.getMessage());
    }
  }
  
  void getTileImage(int pageNumber, double scale, double x, double y, double width, double height, String documentID) {
    try {
      PdfRenderer.Page page = Objects.requireNonNull(documentRepo.get(documentID)).renderer.openPage(pageNumber - 1);
      final Bitmap bitmap = Bitmap.createBitmap((int)width, (int)height, Bitmap.Config.ARGB_8888);
      bitmap.eraseColor(Color.WHITE);
      Matrix matrix = new Matrix();
      matrix.postTranslate((float)-x, (float)-y);
      matrix.postScale((float)(scale), (float)(scale));
      final Rect rect = new Rect(0, 0, (int)width, (int)height);
      page.render(bitmap, rect, matrix, PdfRenderer.Page.RENDER_MODE_FOR_DISPLAY);
      page.close();
      ByteBuffer buffer = ByteBuffer.allocate(bitmap.getByteCount());
      bitmap.copyPixelsToBuffer(buffer);
      bitmap.recycle();
      final byte[] imageBytes = buffer.array();
      buffer.clear();
      resultPdf.success(imageBytes);
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
    } catch (IllegalStateException e) {
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
