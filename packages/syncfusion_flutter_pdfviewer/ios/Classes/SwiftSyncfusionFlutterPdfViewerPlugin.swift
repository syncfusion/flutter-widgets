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
        else if(call.method == "getImage")
        {
            dispatcher.async {
                self.getImage(call:call,result:result)
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
        let args = argument as? [String: Any]
        let documentBytes = args!["documentBytes"] as? FlutterStandardTypedData
        let documentID = args!["documentID"] as! String
        let byte = [UInt8](documentBytes!.data)
        let cfData = CFDataCreate(nil, byte, byte.count)!
        let dataProvider = CGDataProvider(data: cfData)!
        let document = CGPDFDocument(dataProvider)
        self.documentRepo[documentID] = document
        let pageCount = NSNumber(value: document!.numberOfPages)
        result(pageCount.stringValue);
    }

    private func closeDocument(call: FlutterMethodCall, result: @escaping FlutterResult)
    {
        guard let argument = call.arguments else {return}
        let documentID = argument as! String
        self.documentRepo[documentID] = nil
        self.documentRepo.removeValue(forKey: documentID)
    }

    // Returns the width collection of rendered pages.
    private func getPagesWidth( call: FlutterMethodCall, result: @escaping FlutterResult)
    {
        guard let argument = call.arguments else {return}
        let documentID = argument as! String
        guard let document = self.documentRepo[documentID] else {return}
        let pageCount = NSNumber(value: document!.numberOfPages)
        var pagesWidth = Array<Double>()
        for index in stride(from: 1,to: pageCount.intValue + 1, by: 1){
            let page = document!.page(at: Int(index))
            var pageRect = page!.getBoxRect(.cropBox)
            if(page!.rotationAngle > 0)
            {
                let angle = CGFloat(page!.rotationAngle) * CGFloat.pi/180
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
        let documentID = argument as! String
        guard let document = self.documentRepo[documentID] else { return }
        let pageCount = NSNumber(value: document!.numberOfPages)
        var pagesHeight = Array<Double>()
        for index in stride(from: 1,to: pageCount.intValue + 1, by: 1){
            let page = document!.page(at: Int(index))
            var pageRect = page!.getBoxRect(.cropBox)
            if(page!.rotationAngle > 0)
            {
                let angle = CGFloat(page!.rotationAngle) * CGFloat.pi/180
                pageRect = (pageRect.applying(CGAffineTransform(rotationAngle: angle)))
            }
            pagesHeight.append(Double(pageRect.height))
        }
        result(pagesHeight)
    }

    // Gets the pdf page image from the specified page
    private func getImage( call: FlutterMethodCall, result: @escaping FlutterResult)
    {
        guard let argument = call.arguments else {return}
        let args = argument as? [String: Any]
        let index = args!["index"] as? Int
        var scale = CGFloat(args!["scale"] as! Double)
        if(scale < 2)
        {
            scale = 2
        }
        let documentID = args!["documentID"] as! String
        guard let image = getImageForPlugin(index: index!,scale: scale,documentID: documentID) else {
            result(FlutterStandardTypedData())
            return
        }
        result(image)
    }

    private func getImageForPlugin(index: Int,scale: CGFloat,documentID: String) -> FlutterStandardTypedData?
    {
        guard let document = self.documentRepo[documentID] else {return nil}
        let page = document!.page(at: Int(index))
        let pageRect = page!.getBoxRect(.cropBox)
        let imageRect = CGRect(x: 0,y: 0,width: pageRect.size.width*CGFloat(scale),height: pageRect.size.height*CGFloat(scale))
        if #available(iOS 10.0, *) {
            let format = UIGraphicsImageRendererFormat()
                format.scale = 1
            if #available(iOS 12.0, *) {
                format.preferredRange = .standard
            } else {
                format.prefersExtendedRange = false
            }
            let renderer = UIGraphicsImageRenderer(size: imageRect.size,format: format)
            let img = renderer.image { ctx in
                let transform = page!.getDrawingTransform(.cropBox, rect: CGRect(origin: CGPoint.zero, size: pageRect.size), rotate: 0, preserveAspectRatio: true)
                ctx.cgContext.translateBy(x: 0.0, y: imageRect.size.height)
                ctx.cgContext.scaleBy(x: CGFloat(scale), y: -CGFloat(scale))
                ctx.cgContext.concatenate(transform)
                ctx.cgContext.drawPDFPage(page!)
                ctx.cgContext.endPage()
            }
            return FlutterStandardTypedData(bytes: img.pngData()!)
        }
        return FlutterStandardTypedData()
    }

    // Gets the pdf page image from the specified page
    private func getTileImage( call: FlutterMethodCall, result: @escaping FlutterResult)
    {
        guard let argument = call.arguments else {return}
        let args = argument as? [String: Any]
        let pageNumber = args!["pageNumber"] as? Int
        let scale = CGFloat(args!["scale"] as! Double)
        let width = args!["width"] as! Double
        let height = args!["height"] as! Double
        let x = args!["x"] as! Double
        let y = args!["y"] as! Double
 
        let documentID = args!["documentID"] as! String
        guard let tileImage = getTileImageForPlugin(pageNumber: pageNumber!, scale: scale,
                                     width: width, height: height, x: x, y: y, documentID: documentID) else {
            result(FlutterStandardTypedData())
            return
        }
        result(tileImage)
    }
        
    // Gets the image for plugin
    private func getTileImageForPlugin(pageNumber: Int, scale: CGFloat, width: Double, height: Double, x: Double, y: Double, documentID: String) -> FlutterStandardTypedData?
    {
        guard let document = self.documentRepo[documentID] else{return nil}
        let page = document!.page(at: Int(pageNumber))
        let pageRect = page!.getBoxRect(.cropBox)
        
        var pageWidth = pageRect.width
        var pageHeight = pageRect.height
        
        if(page!.rotationAngle == 90 || page!.rotationAngle == 270) {
            pageWidth = pageRect.height
            pageHeight = pageRect.width
        }
        let imageRect = CGRect(x: 0,y: 0, width: width, height: height)
        let bounds = CGRect(x: -(pageWidth * scale / 2) + (pageWidth / 2) - CGFloat(x),
                            y: -(pageHeight * scale / 2) + (pageHeight / 2) + CGFloat(y),
                            width: pageWidth * scale, height: pageHeight * scale)
        if #available(iOS 10.0, *) {
            let format = UIGraphicsImageRendererFormat()
            format.scale = 1
            if #available(iOS 12.0, *) {
                format.preferredRange = .standard
            } else {
                format.prefersExtendedRange = false
            }
            let renderer = UIGraphicsImageRenderer(size: imageRect.size,format: format)
            
            let img = renderer.image { ctx in
                let transform = page!.getDrawingTransform(.cropBox, rect: bounds, rotate: 0, preserveAspectRatio: true)
                ctx.cgContext.translateBy(x: 0.0, y: pageHeight * scale)
                ctx.cgContext.scaleBy(x: scale, y: -scale)
                ctx.cgContext.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                ctx.cgContext.fill(bounds)
                ctx.cgContext.concatenate(transform)
                ctx.cgContext.drawPDFPage(page!)
                ctx.cgContext.endPage()
            }
            return FlutterStandardTypedData(bytes: img.pngData()!)
        }
        return FlutterStandardTypedData()
    }
}
