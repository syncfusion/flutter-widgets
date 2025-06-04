package com.syncfusion.flutter.pdfviewer.android;

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
public class SyncfusionFlutterPdfViewerPdfiumPlugin implements FlutterPlugin, MethodCallHandler {
    private MethodChannel channel;
    private ExecutorService executorService;

    private HashMap<String, Long> documentHandleMap = new HashMap<>();

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        if (Build.VERSION.SDK_INT <= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            boolean initSuccess = PdfiumAdapter.initLibrary();
            if (initSuccess) {
                channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "syncfusion_flutter_pdfviewer");
                channel.setMethodCallHandler(this);
                executorService = Executors.newFixedThreadPool(Runtime.getRuntime().availableProcessors());
            }
        }
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
        if (channel != null) {
            channel.setMethodCallHandler(null);
        }
        if (executorService != null && !executorService.isShutdown()) {
            executorService.shutdown();
        }
        PdfiumAdapter.destroyLibrary();
    }

    private void getPage(MethodCall call, Result result) {
        int pageIndex = call.argument("index");
        int width = call.argument("width");
        int height = call.argument("height");
        String documentID = call.argument("documentID");

        Long docHandle = documentHandleMap.get(documentID);

        if (docHandle == null) {
            result.error("ERROR", "Document not found", null);
        }

        try {
            byte[] imageBytes = PdfiumAdapter.renderPage(docHandle, pageIndex - 1, width, height);
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
        Long docHandle = documentHandleMap.get(documentID);

        if (docHandle == null) {
            result.error("ERROR", "Document not found", null);
        }

        try {
            byte[] imageBytes = PdfiumAdapter.renderTile(docHandle, pageNumber - 1, (float) x, (float) y, (int)width, (int)height, (float) scale);
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
                if (password == null) {
                    password = "";
                }
                long docHandle = PdfiumAdapter.loadDocument(bytes, password);
                documentHandleMap.put(documentID, docHandle);
                int pageCount = PdfiumAdapter.getPageCount(docHandle);                
                result.success(String.valueOf(pageCount));
            } catch (SecurityException e) {
                result.error("PASSWORD_ERROR", "Incorrect password or document is encrypted", null);
            } catch (Exception e) {
                result.error("PDF_RENDERER_ERROR", e.getMessage(), null);
            }
        });
    }

    private void getPagesWidth(MethodCall call, Result result) {
        String documentID = (String) call.arguments;
        Long docHandle = documentHandleMap.get(documentID);

        if (docHandle == null) {
            result.error("ERROR", "Document not found", null);
        }
       
        executorService.execute(() -> {
            try {
                int count = PdfiumAdapter.getPageCount(docHandle);
                double[] pageWidth = new double[count];
                for (int i = 0; i < count; i++) {
                    pageWidth[i] = PdfiumAdapter.getPageWidth(docHandle, i);
                }
                result.success(pageWidth);
            } catch (Exception e) {
                result.error("PAGE_WIDTH_ERROR", e.getMessage(), null);
            }
        });
    }

    private void getPagesHeight(MethodCall call, Result result) {
        String documentID = (String) call.arguments;
        Long docHandle = documentHandleMap.get(documentID);

        if (docHandle == null) {
            result.error("ERROR", "Document not found", null);
        }

        executorService.execute(() -> {
            try {
                int count = PdfiumAdapter.getPageCount(docHandle);
                double[] pageHeight = new double[count];
                for (int i = 0; i < count; i++) {
                    pageHeight[i] = PdfiumAdapter.getPageHeight(docHandle, i);
                }
                result.success(pageHeight);
            } catch (Exception e) {
                result.error("PAGE_HEIGHT_ERROR", e.getMessage(), null);
            }
        });
    }

    private void closeDocument(MethodCall call, Result result) {
        String documentID = (String) call.arguments;
        Long docHandle = documentHandleMap.get(documentID);

        if (docHandle == null) {
            result.error("ERROR", "Document not found", null);
        }
        PdfiumAdapter.closeDocument(docHandle);
        documentHandleMap.remove(docHandle);
        result.success(true);
    }
}