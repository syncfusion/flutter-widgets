import Flutter
import UIKit
 
 
 
// SyncfusionFlutterPdfViewerPlugin
public class SwiftSyncfusionFlutterPdfViewerPlugin: NSObject, FlutterPlugin {
    // Document repository
    var documentRepo = [String: CGPDFDocument?]()
    
    let dispatcher = DispatchQueue(label: "syncfusion_flutter_pdfviewer")
    
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
        else if(call.method == "getPage")
        {
            dispatcher.async {
                self.getPage(call:call,result:result)
            }
        }
        else if(call.method == "getTileImage")
        {
            dispatcher.async {
                self.getTileImage(call:call,result:result)
            }
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
            closeDocument(call:call,result:result)
        }
    }
    
    // Initializes the PDF Renderer and returns the page count.
    private func initializePdfRenderer( call: FlutterMethodCall, result: @escaping FlutterResult)
    {
        guard let argument = call.arguments else {return}
        guard let args = argument as? [String: Any] else {return}
        guard let documentBytes = args["documentBytes"] as? FlutterStandardTypedData else {return}
        guard let documentID = args["documentID"] as? String else {return}
        let byte = [UInt8](documentBytes.data)
        guard let cfData = CFDataCreate(nil, byte, byte.count) else {return}
        guard let dataProvider = CGDataProvider(data: cfData) else {return}
        guard let document = CGPDFDocument(dataProvider) else {return}
        self.documentRepo[documentID] = document
        let pageCount = NSNumber(value: document.numberOfPages)
        result(pageCount.stringValue);
    }
    
    private func closeDocument(call: FlutterMethodCall, result: @escaping FlutterResult)
    {
        guard let argument = call.arguments else {return}
        guard let documentID = argument as? String else {return}
        self.documentRepo[documentID] = nil
        self.documentRepo.removeValue(forKey: documentID)
    }
    
    // Returns the width collection of rendered pages.
    private func getPagesWidth( call: FlutterMethodCall, result: @escaping FlutterResult)
    {
        guard let argument = call.arguments else {return}
        guard let documentID = argument as? String else {return}
        guard let document = self.documentRepo[documentID] else {return}
        let pageCount = NSNumber(value: document!.numberOfPages)
        var pagesWidth = Array<Double>()
        for index in stride(from: 1,to: pageCount.intValue + 1, by: 1){
            guard let page = document!.page(at: Int(index)) else {continue}
            var pageRect = page.getBoxRect(.cropBox)
            if(page.rotationAngle > 0)
            {
                let angle = CGFloat(page.rotationAngle) * CGFloat.pi/180
                pageRect = (pageRect.applying(CGAffineTransform(rotationAngle: angle)))
            }
            pagesWidth.append(Double(pageRect.width))
        }
        result(pagesWidth)
    }
    
    // Returns the height collection of rendered pages.
    private func getPagesHeight( call: FlutterMethodCall, result: @escaping FlutterResult)
    {
        guard let argument = call.arguments else {return}
        guard let documentID = argument as? String else {return}
        guard let document = self.documentRepo[documentID] else { return }
        let pageCount = NSNumber(value: document!.numberOfPages)
        var pagesHeight = Array<Double>()
        for index in stride(from: 1,to: pageCount.intValue + 1, by: 1){
            guard let page = document!.page(at: Int(index)) else {continue}
            var pageRect = page.getBoxRect(.cropBox)
            if(page.rotationAngle > 0)
            {
                let angle = CGFloat(page.rotationAngle) * CGFloat.pi/180
                pageRect = (pageRect.applying(CGAffineTransform(rotationAngle: angle)))
            }
            pagesHeight.append(Double(pageRect.height))
        }
        result(pagesHeight)
    }
    
    // Gets the image bytes of the specified page from the document at the specified width and height.
    private func getPage( call: FlutterMethodCall, result: @escaping FlutterResult)
    {
        guard let argument = call.arguments else {return}
        guard let args = argument as? [String: Any] else {return}
        guard let index = args["index"] as? Int else {return}
        guard let width = args["width"] as? Int else {return}
        guard let height = args["height"] as? Int else {return}
        guard let documentID = args["documentID"] as? String else {return}
        guard let image = getImageForPlugin(index: index, width: width, height: height,documentID: documentID) else {
            return
        }
        result(image)
    }
    
    private func getImageForPlugin(index: Int,width:Int, height:Int,documentID: String) -> FlutterStandardTypedData?
    {
        guard let document = self.documentRepo[documentID] else {return nil}
        guard let page = document!.page(at: Int(index)) else {return nil}
        let pageRect = page.getBoxRect(.cropBox)
        var pageWidth = pageRect.width
        var pageHeight = pageRect.height
        if(page.rotationAngle == 90 || page.rotationAngle == 270) {
            pageWidth = pageRect.height
            pageHeight = pageRect.width
        }
        let imageRect = CGRect(x: 0,y: 0,width: width,height: height)
        let scaleX = Double(width) / Double(pageWidth)
        let scaleY = Double(height) / Double(pageHeight)
        let stride = width * 4
        let bufSize = stride * height;
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufSize)
        buffer.initialize(repeating:  0, count: bufSize)
        var rendered = false
        let transform = page.getDrawingTransform(.cropBox, rect: CGRect(origin: CGPoint.zero, size: CGSize(width: pageWidth, height: pageHeight)), rotate: 0, preserveAspectRatio: true)
        let rgb = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: buffer, width: width, height: height, bitsPerComponent: 8, bytesPerRow: stride, space: rgb, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        if context != nil {
            context!.setAllowsAntialiasing(true);
            context!.translateBy(x: 0, y: 0)
            context!.scaleBy(x: scaleX, y: scaleY)
            context!.concatenate(transform)
            context!.drawPDFPage(page)
            rendered = true
        }
        if(rendered){
            let data = Data(bytesNoCopy: buffer, count: bufSize, deallocator: .none)
            return FlutterStandardTypedData(bytes: data)
        }else{
            return nil
        }
    }
    
    // Gets the pdf page image from the specified page
    private func getTileImage( call: FlutterMethodCall, result: @escaping FlutterResult)
    {
        guard let argument = call.arguments else {return}
        guard let args = argument as? [String: Any] else {return}
        guard let pageNumber = args["pageNumber"] as? Int else {return}
        guard let scale = args["scale"] as? Double else {return}
        guard let width = args["width"] as? Double else {return}
        guard let height = args["height"] as? Double else {return}
        guard let x = args["x"] as? Double else {return}
        guard let y = args["y"] as? Double else {return}
        
        guard let documentID = args["documentID"] as? String else {return}
        guard let tileImage = getTileImageForPlugin(pageNumber: pageNumber, scale: CGFloat(scale),
                                                    width: width, height: height, x: x, y: y, documentID: documentID) else {
            return
        }
        result(tileImage)
    }
    
    // Gets the image for plugin
    private func getTileImageForPlugin(pageNumber: Int, scale: CGFloat, width: Double, height: Double, x: Double, y: Double, documentID: String) -> FlutterStandardTypedData?
    {
        guard let document = self.documentRepo[documentID] else {return nil}
        guard let page = document!.page(at: Int(pageNumber)) else {return nil}
        let pageRect = page.getBoxRect(.cropBox)
        var pageWidth = pageRect.width
        var pageHeight = pageRect.height
        if(page.rotationAngle == 90 || page.rotationAngle == 270) {
            pageWidth = pageRect.height
            pageHeight = pageRect.width
        }
        let bounds = CGRect(x: -(pageWidth * scale / 2) + (pageWidth / 2) - CGFloat(x),
                            y: -(pageHeight * scale / 2) + (pageHeight / 2) + CGFloat(y),
                            width: pageWidth * scale, height: pageHeight * scale)
        
        let stride = Int(width) * 4
        let bufSize = stride * Int(height);
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufSize)
        buffer.initialize(repeating:  0, count: bufSize)
        var rendered = false
        let transform = page.getDrawingTransform(.cropBox, rect: CGRect(origin: CGPoint.zero, size: CGSize(width: pageWidth, height: pageHeight)), rotate: 0, preserveAspectRatio: true)
        let rgb = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: buffer, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: stride, space: rgb, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        if context != nil {
            context!.setAllowsAntialiasing(true);
            context!.translateBy(x: CGFloat(-x * scale), y: CGFloat(((y * scale) + height) - bounds.height))
            context!.scaleBy(x: scale, y: scale)
            context!.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            context!.fill(bounds)
            context!.concatenate(transform)
            context!.drawPDFPage(page)
            rendered = true
        }
        if(rendered){
            let data = Data(bytesNoCopy: buffer, count: bufSize, deallocator: .none)
            return FlutterStandardTypedData(bytes: data)
        }else{
            return nil
        }
    }
}