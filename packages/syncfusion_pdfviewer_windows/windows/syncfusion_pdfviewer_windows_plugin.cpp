#include "include/syncfusion_pdfviewer_windows/syncfusion_pdfviewer_windows_plugin.h"

#pragma warning(disable : 4458)

// Windows and GDIPlus header need to be added before other include statement.
#include <windows.h>
#include <gdiplus.h>

// Include Pdfium header to access the PDF document related APIs.
#include <fpdfview.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

// Standard header import.
#include <iostream>
#include <map>
#include <memory>
#include <sstream>
#include <stdexcept>

// GDI library linking.
#pragma comment(lib, "gdiplus.lib")

#include "pdfviewer.h"

namespace pdfviewer
{
  /// Windows plugin class for Flutter PdfViewer.
  class SyncfusionPdfviewerWindowsPlugin : public flutter::Plugin
  {
  public:
    static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

    SyncfusionPdfviewerWindowsPlugin();

    virtual ~SyncfusionPdfviewerWindowsPlugin();

  private:
    // Called when a method is called on this plugin's channel from Dart.
    void HandleMethodCall(
        const flutter::MethodCall<flutter::EncodableValue> &method_call,
        std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  };

  void SyncfusionPdfviewerWindowsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarWindows *registrar)
  {
    auto channel =
        std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
            registrar->messenger(), "syncfusion_flutter_pdfviewer",
            &flutter::StandardMethodCodec::GetInstance());

    auto plugin = std::make_unique<SyncfusionPdfviewerWindowsPlugin>();

    channel->SetMethodCallHandler(
        [plugin_pointer = plugin.get()](const auto &call, auto result)
        {
          plugin_pointer->HandleMethodCall(call, std::move(result));
        });

    registrar->AddPlugin(std::move(plugin));
  }

  SyncfusionPdfviewerWindowsPlugin::SyncfusionPdfviewerWindowsPlugin() {}

  SyncfusionPdfviewerWindowsPlugin::~SyncfusionPdfviewerWindowsPlugin() {}

  /// Initailizes the Pdf Renderer for image extraction
  void InitializePdfRenderer(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
  {
    const auto *arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
    auto documentBytes = arguments->find(flutter::EncodableValue("documentBytes"));
    auto documentID = arguments->find(flutter::EncodableValue("documentID"));
    auto id = std::get<std::string>(documentID->second);
    auto bytes = std::get<std::vector<uint8_t>>(documentBytes->second);
    std::shared_ptr<PdfDocument> document = initializePdfRenderer(bytes, id);
    int pageCount = FPDF_GetPageCount(document->pdfDocument);
    result->Success(flutter::EncodableValue(std::to_string(pageCount)));
  }

  /// Gets the PDF pages height
  void GetPagesHeight(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
  {
    auto id = std::get<std::string>(*method_call.arguments());
    std::shared_ptr<PdfDocument> documentPtr = getPdfDocument(id);
    if (documentPtr == nullptr)
    {
      result->Error("Error", "Document not found");
      return;
    }
    int pageCount = FPDF_GetPageCount(documentPtr->pdfDocument);
    std::vector<double> pageHeights;
    for (int pageIndex = 0; pageIndex < pageCount; pageIndex++)
    {
      FPDF_PAGE page = FPDF_LoadPage(documentPtr->pdfDocument, pageIndex);
      double height = FPDF_GetPageHeightF(page);
      pageHeights.push_back(height);
      FPDF_ClosePage(page);
    }
    result->Success(flutter::EncodableValue(pageHeights));
  }

  /// Gets the PDF pages width
  void GetPagesWidth(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
  {
    auto id = std::get<std::string>(*method_call.arguments());
    std::shared_ptr<PdfDocument> documentPtr = getPdfDocument(id);
    if (documentPtr == nullptr)
    {
      result->Error("Error", "Document not found");
      return;
    }
    int pageCount = FPDF_GetPageCount(documentPtr->pdfDocument);
    std::vector<double> pageWidth;
    for (int pageIndex = 0; pageIndex < pageCount; pageIndex++)
    {
      FPDF_PAGE page = FPDF_LoadPage(documentPtr->pdfDocument, pageIndex);
      double width = FPDF_GetPageWidthF(page);
      pageWidth.push_back(width);
      FPDF_ClosePage(page);
    }
    result->Success(flutter::EncodableValue(pageWidth));
  }

  /// Returns encoder and set clsid for PNG image.
  int GetPNGImageID(CLSID *requestedClsid)
  {
    UINT encoderCount = 0;
    UINT encoderSize = 0;

    Gdiplus::GetImageEncodersSize(&encoderCount, &encoderSize);
    if (encoderSize == 0)
      return -1;

    Gdiplus::ImageCodecInfo *imageCodecInfo = (Gdiplus::ImageCodecInfo *)(malloc(encoderSize));
    if (imageCodecInfo == NULL)
      return -1;

    GetImageEncoders(encoderCount, encoderSize, imageCodecInfo);

    for (UINT encoder = 0; encoder < encoderCount; ++encoder)
    {
      if (wcscmp(imageCodecInfo[encoder].MimeType, L"image/png") == 0)
      {
        *requestedClsid = imageCodecInfo[encoder].Clsid;
        free(imageCodecInfo);
        return encoder;
      }
    }

    free(imageCodecInfo);
    return -1;
  }

  /// Gets PDF page image
  void GetPdfPageImage(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
  {
    const auto *arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
    auto pageIndex = arguments->find(flutter::EncodableValue("index"));
    auto currentScale = arguments->find(flutter::EncodableValue("scale"));
    auto documentID = arguments->find(flutter::EncodableValue("documentID"));
    auto id = std::get<std::string>(documentID->second);
    auto scale = std::get<double>(currentScale->second);
    auto index = std::get<int>(pageIndex->second);
    std::shared_ptr<PdfDocument> documentPtr = getPdfDocument(id);
    if (documentPtr == nullptr)
    {
      result->Error("Error", "Document not found");
      return;
    }
    FPDF_DOCUMENT document = documentPtr->pdfDocument;
    FPDF_PAGE page = FPDF_LoadPage(document, index - 1);
    if (scale < 1.75)
    {
      scale = 1.75;
    }
    int pageWidth = (int)(FPDF_GetPageWidthF(page) * scale);
    int pageHeight = (int)(FPDF_GetPageHeightF(page) * scale);
    // Create empty bitmap and render page onto it
    auto bitmap = FPDFBitmap_Create(pageWidth, pageHeight, 0);
    FPDFBitmap_FillRect(bitmap, 0, 0, pageWidth, pageHeight, 0xFFFFFFFF);
    FPDF_RenderPageBitmap(bitmap, page, 0, 0, pageWidth, pageHeight, 0, FPDF_LCD_TEXT);

    // Convert bitmap into RGBA format
    uint8_t *scanArg = static_cast<uint8_t *>(FPDFBitmap_GetBuffer(bitmap));
    auto bitmapStride = FPDFBitmap_GetStride(bitmap);

    // Convert to image format
    Gdiplus::GdiplusStartupInput gdiplusStartupInput;
    ULONG_PTR tokenGDI;
    Gdiplus::GdiplusStartup(&tokenGDI, &gdiplusStartupInput, NULL);

    // Get the CLSID of the image encoder.
    CLSID pngClsid;
    GetPNGImageID(&pngClsid);

    // Create gdi+ bitmap from raw image data
    auto gdiBitmap =
        new Gdiplus::Bitmap(pageWidth, pageHeight, bitmapStride, PixelFormat32bppRGB, scanArg);

    // Create stream for converted image
    IStream *stream = nullptr;
    CreateStreamOnHGlobal(NULL, TRUE, &stream);

    // Encode image onto stream
    auto gdiStatus = gdiBitmap->Save(stream, &pngClsid, NULL);
    if (gdiStatus == Gdiplus::OutOfMemory)
    {
      throw std::exception("Image encode failed due to out of memory");
    }
    else if (gdiStatus != Gdiplus::Ok)
    {
      throw std::exception("Image endode failed");
    }

    // Get raw memory of stream
    HGLOBAL global = NULL;
    GetHGlobalFromStream(stream, &global);

    // copy IStream to buffer
    size_t bufferSize = GlobalSize(global);
    std::vector<uint8_t> imageData;
    imageData.resize(bufferSize);

    // lock & unlock memory
    LPVOID lockImage = GlobalLock(global);
    memcpy(&imageData[0], lockImage, bufferSize);
    GlobalUnlock(global);

    // Close stream
    stream->Release();

    // Cleanup gid+
    delete gdiBitmap;
    Gdiplus::GdiplusShutdown(tokenGDI);

    FPDFBitmap_Destroy(bitmap);
    FPDF_ClosePage(page);

    result->Success(flutter::EncodableValue(imageData));
  }

  void GetPdfPageTileImage(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
  {
    const auto *arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
    auto pageNumberArgument = arguments->find(flutter::EncodableValue("pageNumber"));
    auto currentScale = arguments->find(flutter::EncodableValue("scale"));
    auto documentID = arguments->find(flutter::EncodableValue("documentID"));
    auto xArgument = arguments->find(flutter::EncodableValue("x"));
    auto yArgument = arguments->find(flutter::EncodableValue("y"));
    auto widthArgument = arguments->find(flutter::EncodableValue("width"));
    auto heightArgument = arguments->find(flutter::EncodableValue("height"));
    auto id = std::get<std::string>(documentID->second);
    auto scale = std::get<double>(currentScale->second);
    auto pageNumber = std::get<int>(pageNumberArgument->second);
    auto x = std::get<double>(xArgument->second);
    auto y = std::get<double>(yArgument->second);
    int width = (int)std::get<double>(widthArgument->second);
    int height = (int)std::get<double>(heightArgument->second);
    FPDF_DOCUMENT document = getPdfDocument(id)->pdfDocument;
    FPDF_PAGE page = FPDF_LoadPage(document, pageNumber - 1);

    FS_MATRIX matrix = {(float)scale, 0, 0, (float)scale, (float)(-x * scale), (float)(-y * scale)};
    FS_RECTF rect = {0,0, (float)(width * scale), (float)(height * scale)};

    // Create empty bitmap and render page onto it
    auto bitmap = FPDFBitmap_Create(width, height, 0);
    FPDFBitmap_FillRect(bitmap, 0, 0, width, height, 0xFFFFFFFF);
    FPDF_RenderPageBitmapWithMatrix(bitmap, page, &matrix, &rect, 0);

    // Convert bitmap into RGBA format
    uint8_t *scanArg = static_cast<uint8_t *>(FPDFBitmap_GetBuffer(bitmap));
    auto bitmapStride = FPDFBitmap_GetStride(bitmap);

    // Convert to image format
    Gdiplus::GdiplusStartupInput gdiplusStartupInput;
    ULONG_PTR tokenGDI;
    Gdiplus::GdiplusStartup(&tokenGDI, &gdiplusStartupInput, NULL);

    // Get the CLSID of the image encoder.
    CLSID pngClsid;
    GetPNGImageID(&pngClsid);

    // Create gdi+ bitmap from raw image data
    auto gdiBitmap =
        new Gdiplus::Bitmap(width, height, bitmapStride, PixelFormat32bppRGB, scanArg);

    // Create stream for converted image
    IStream *stream = nullptr;
    CreateStreamOnHGlobal(NULL, TRUE, &stream);

    // Encode image onto stream
    auto gdiStatus = gdiBitmap->Save(stream, &pngClsid, NULL);
    if (gdiStatus == Gdiplus::OutOfMemory)
    {
      throw std::exception("Image encode failed due to out of memory");
    }
    else if (gdiStatus != Gdiplus::Ok)
    {
      throw std::exception("Image endode failed");
    }

    // Get raw memory of stream
    HGLOBAL global = NULL;
    GetHGlobalFromStream(stream, &global);

    // copy IStream to buffer
    size_t bufferSize = GlobalSize(global);
    std::vector<uint8_t> imageData;
    imageData.resize(bufferSize);

    // lock & unlock memory
    LPVOID lockImage = GlobalLock(global);
    memcpy(&imageData[0], lockImage, bufferSize);
    GlobalUnlock(global);

    // Close stream
    stream->Release();

    // Cleanup gid+
    delete gdiBitmap;
    Gdiplus::GdiplusShutdown(tokenGDI);

    FPDFBitmap_Destroy(bitmap);
    FPDF_ClosePage(page);

    result->Success(flutter::EncodableValue(imageData));
  }

  void SyncfusionPdfviewerWindowsPlugin::HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
  {
    if (method_call.method_name().compare("initializePdfRenderer") == 0)
    {
      InitializePdfRenderer(method_call, std::move(result));
    }
    else if (method_call.method_name().compare("getPagesHeight") == 0)
    {
      GetPagesHeight(method_call, std::move(result));
    }
    else if (method_call.method_name().compare("getPagesWidth") == 0)
    {
      GetPagesWidth(method_call, std::move(result));
    }
    else if (method_call.method_name().compare("getImage") == 0)
    {
      GetPdfPageImage(method_call, std::move(result));
    }
    else if (method_call.method_name().compare("getTileImage") == 0)
    {
      GetPdfPageTileImage(method_call, std::move(result));
    }
    else if (method_call.method_name().compare("closeDocument") == 0)
    {
      auto id = std::get<std::string>(*method_call.arguments());
      closePdfDocument(id);
      result->Success();
    }
    else
    {
      result->NotImplemented();
    }
  }
} // namespace

void SyncfusionPdfviewerWindowsPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar)
{
  pdfviewer::SyncfusionPdfviewerWindowsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
