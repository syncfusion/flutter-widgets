import Flutter
import UIKit

// SyncfusionFlutterPdfViewerPlugin
public class SwiftSyncfusionFlutterPdfViewerPlugin: NSObject, FlutterPlugin {

    // Instance of CGPDFDocument
    var document : CGPDFDocument?
    // Width collection of rendered pages
    var pagesWidth: Array<Double>
    // Height collection of rendered pages
    var pagesHeight: Array<Double>
    // Number of pages in PDF document
    var pageCount: NSNumber
    // PDF path
    var url: URL!

    // Initializes the SyncfusionFlutterPdfViewerPlugin
    override init(){
        pagesWidth = Array<Double>()
        pagesHeight = Array<Double>()
        pageCount = NSNumber(0)
        document = nil
        url = nil
    }
    
    private func dispose()
    {
        self.document = nil
        self.pageCount = NSNumber(0)
        self.pagesHeight.removeAll()
        self.pagesWidth.removeAll()
        self.url = nil
    }

  // Registers the SyncfusionFlutterPdfViewerPlugin
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "syncfusion_flutter_pdfviewer", binaryMessenger: registrar.messenger())
    let instance = SwiftSyncfusionFlutterPdfViewerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  // Invokes the method call operations.
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "getimages") {
            getImages(call:call,result:result)
         }
    else if(call.method == "initializepdfrenderer")
        {
            initializePdfRenderer(call:call,result:result);
    }
    else if(call.method == "getimage")
    {
     getImage(call:call,result:result)
    }
    else if(call.method == "getpageswidth")
    {
     getPagesWidth(call:call,result:result)
    }
    else if(call.method == "getpagesheight")
    {
     getPagesHeight(call:call,result:result)
    }
    else if(call.method == "dispose")
    {
     dispose()
    }
  }
    
  // Initializes the PDF Renderer and returns the page count.
   private func initializePdfRenderer( call: FlutterMethodCall, result: @escaping FlutterResult)
       {
           self.url =  URL(fileURLWithPath: call.arguments as! String)
           self.document =  CGPDFDocument(url as CFURL)
           self.pageCount = NSNumber(value: self.document!.numberOfPages)
           result(self.pageCount.stringValue);
    }
    
    // Reinitailize PDF Renderer if the given document URL is different from current document URL
    private func reinitializePdfRenderer(path : URL)
    {
        if(self.url == nil || self.url.absoluteString != path.absoluteString)
            {
              self.url = path
              self.document = CGPDFDocument(url as CFURL)!
              self.pageCount = NSNumber(value: self.document!.numberOfPages)
        }
    }
    
    // Gets the pdf pages images from the specified page
    private func getImages( call: FlutterMethodCall, result: @escaping FlutterResult)
    {
        self.pagesWidth.removeAll()
        self.pagesHeight.removeAll()
        var bitmaps = [FlutterStandardTypedData]()
        guard let argument = call.arguments else {return}
        let args = argument as? [String: Any]
        let path = args!["path"] as? String
        reinitializePdfRenderer(path: URL(fileURLWithPath: path!))
        let startIndex = args!["firstPage"] as? Int
        let endIndex = args!["lastPage"] as? Int
        for index in stride(from: startIndex!,to: endIndex!+1, by: 1){
            bitmaps.append(getImageForPlugin(index: index))
        }
        result(bitmaps);
    }
    private func getImageForPlugin(index: Int) -> FlutterStandardTypedData
    {
        let page = self.document!.page(at: Int(index))
                   let pageRect = page!.getBoxRect(.mediaBox)
                   self.pagesWidth.append(Double(pageRect.width))
                   self.pagesHeight.append(Double(pageRect.height))
                   if #available(iOS 10.0, *) {
                       let renderer = UIGraphicsImageRenderer(size: pageRect.size)
                       let img = renderer.image { ctx in
                           UIColor.white.set()
                           ctx.fill(pageRect)

                           ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
                           ctx.cgContext.scaleBy(x: 1.0, y: -1.0)

                           ctx.cgContext.drawPDFPage(page!)
                       }
                       return FlutterStandardTypedData(bytes: img.pngData()!)
                   } else {
                    return FlutterStandardTypedData()
        }
    }
    // Gets the pdf page image from the specified page
     private func getImage( call: FlutterMethodCall, result: @escaping FlutterResult)
       {
        self.pagesWidth.removeAll()
        self.pagesHeight.removeAll()
        var bitmaps = [FlutterStandardTypedData]()
        guard let argument = call.arguments else {return}
        let args = argument as? [String: Any]
        let path = args!["path"] as? String
        let index = args!["index"] as? Int
        reinitializePdfRenderer(path: URL(fileURLWithPath: path!))
        bitmaps.append(getImageForPlugin(index: index!))
        result(bitmaps);
    }

  // Returns the width collection of rendered pages.
    private func getPagesWidth( call: FlutterMethodCall, result: @escaping FlutterResult)
       {
        reinitializePdfRenderer(path: URL(fileURLWithPath: call.arguments as! String))
        pagesWidth = Array<Double>()
        for index in stride(from: 1,to: self.pageCount.intValue + 1, by: 1){
                let page = self.document!.page(at: Int(index))
                          let pageRect = page!.getBoxRect(.mediaBox)
                   self.pagesWidth.append(Double(pageRect.width))
        }
        result(pagesWidth)
    }

  // Returns the height collection of rendered pages.
    private func getPagesHeight( call: FlutterMethodCall, result: @escaping FlutterResult)
       {
        reinitializePdfRenderer(path: URL(fileURLWithPath: call.arguments as! String))
        pagesHeight = Array<Double>()
               for index in stride(from: 1,to: self.pageCount.intValue + 1, by: 1){
                let page = self.document!.page(at: Int(index))
                          let pageRect = page!.getBoxRect(.mediaBox)
                          self.pagesHeight.append(Double(pageRect.height))
        }
        result(pagesHeight)
    }
}
