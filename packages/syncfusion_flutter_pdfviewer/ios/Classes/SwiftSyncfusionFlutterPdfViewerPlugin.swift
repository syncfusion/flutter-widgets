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
    var bytes: FlutterStandardTypedData!
    
    // Initializes the SyncfusionFlutterPdfViewerPlugin
    override init(){
        pagesWidth = Array<Double>()
        pagesHeight = Array<Double>()
        pageCount = NSNumber(0)
        document = nil
        bytes = nil
    }
    
    private func closeDocument()
    {
        self.document = nil
        self.pageCount = NSNumber(0)
        self.pagesHeight.removeAll()
        self.pagesWidth.removeAll()
        self.bytes = nil
    }
    
    // Registers the SyncfusionFlutterPdfViewerPlugin
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "syncfusion_flutter_pdfviewer", binaryMessenger: registrar.messenger())
        let instance = SwiftSyncfusionFlutterPdfViewerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    // Invokes the method call operations.
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if(call.method == "initializePdfRenderer")
        {
            initializePdfRenderer(call:call,result:result)
        }
        else if(call.method == "getImage")
        {
            getImage(call:call,result:result)
        }
        else if(call.method == "getPagesWidth")
        {
            getPagesWidth(call:call,result:result)
        }
        else if(call.method == "getPagesHeight")
        {
            getPagesHeight(call:call,result:result)
        }
        else if(call.method == "closeDocument")
        {
            closeDocument()
        }
    }
    
    // Initializes the PDF Renderer and returns the page count.
    private func initializePdfRenderer( call: FlutterMethodCall, result: @escaping FlutterResult)
    {
        self.bytes =  call.arguments as? FlutterStandardTypedData
        let byte = [UInt8](self.bytes.data)
        let cfData = CFDataCreate(nil, byte, byte.count)!
        let dataProvider = CGDataProvider(data: cfData)!
        self.document = CGPDFDocument(dataProvider)
        self.pageCount = NSNumber(value: self.document!.numberOfPages)
        result(self.pageCount.stringValue);
    }
    
    // Returns the width collection of rendered pages.
    private func getPagesWidth( call: FlutterMethodCall, result: @escaping FlutterResult)
    {
        pagesWidth = Array<Double>()
        for index in stride(from: 1,to: self.pageCount.intValue + 1, by: 1){
            let page = self.document!.page(at: Int(index))
            var pageRect = page!.getBoxRect(.mediaBox)
            if(page!.rotationAngle > 0)
            {
                let angle = CGFloat(page!.rotationAngle) * CGFloat.pi/180
                pageRect = (pageRect.applying(CGAffineTransform(rotationAngle: angle)))
            }
            self.pagesWidth.append(Double(pageRect.width))
        }
        result(pagesWidth)
    }
    
    // Returns the height collection of rendered pages.
    private func getPagesHeight( call: FlutterMethodCall, result: @escaping FlutterResult)
    {
        pagesHeight = Array<Double>()
        for index in stride(from: 1,to: self.pageCount.intValue + 1, by: 1){
            let page = self.document!.page(at: Int(index))
            var pageRect = page!.getBoxRect(.mediaBox)
            if(page!.rotationAngle > 0)
            {
                let angle = CGFloat(page!.rotationAngle) * CGFloat.pi/180
                pageRect = (pageRect.applying(CGAffineTransform(rotationAngle: angle)))
            }
            self.pagesHeight.append(Double(pageRect.height))
        }
        result(pagesHeight)
    }
    
    // Gets the pdf page image from the specified page
    private func getImage( call: FlutterMethodCall, result: @escaping FlutterResult)
    {
        guard let argument = call.arguments else {return}
        let args = argument as? [String: Any]
        let index = args!["index"] as? Int
        result(getImageForPlugin(index: index!))
    }
    
    private func getImageForPlugin(index: Int) -> FlutterStandardTypedData
    {
        if(self.document != nil)
        {
            let page = self.document!.page(at: Int(index))
            var pageRect = page!.getBoxRect(.mediaBox)
            if #available(iOS 10.0, *) {
              let format = UIGraphicsImageRendererFormat()
               if #available(iOS 12.0, *) {
                  format.preferredRange = .standard
               } else {
                   format.prefersExtendedRange = false
                 }
                let renderer = UIGraphicsImageRenderer(size: pageRect.size,format: format)
                let img = renderer.image { ctx in
                    let mediaBox = page!.getBoxRect(.mediaBox)
                    ctx.cgContext.beginPage(mediaBox: &pageRect)
                    let transform = page!.getDrawingTransform(.mediaBox, rect: mediaBox, rotate: 0, preserveAspectRatio: true)
                    ctx.cgContext.translateBy(x: 0.0, y: mediaBox.size.height)
                    ctx.cgContext.scaleBy(x: 1, y: -1)
                    ctx.cgContext.concatenate(transform)
                    ctx.cgContext.drawPDFPage(page!)
                    ctx.cgContext.endPage()
                }
                return FlutterStandardTypedData(bytes: img.pngData()!)
            }
        }
        return FlutterStandardTypedData()
    }
}
