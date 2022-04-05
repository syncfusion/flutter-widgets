import Cocoa
import FlutterMacOS
import CoreGraphics
import Foundation
import AppKit

public class SyncfusionFlutterPdfViewerPlugin: NSObject, FlutterPlugin {
    
    // Document repository
    var documentRepo = [String: CGPDFDocument?]()
    
    // Registers the SyncfusionFlutterPdfViewerPlugin
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "syncfusion_flutter_pdfviewer", binaryMessenger: registrar.messenger)
        let instance = SyncfusionFlutterPdfViewerPlugin()
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
            closeDocument(call:call,result:result)
        }
    }
    
    // Initializes the PDF Renderer and returns the page count.
    private func initializePdfRenderer( call: FlutterMethodCall, result: @escaping FlutterResult)
    {
        guard let argument = call.arguments else {return}
        let args = argument as? [String: Any]
        let documentBytes = args!["documentBytes"] as? FlutterStandardTypedData
        let currentDocumentID = args!["documentID"] as! String
        let byte = [UInt8](documentBytes!.data)
        let cfData = CFDataCreate(nil, byte, byte.count)!
        let dataProvider = CGDataProvider(data: cfData)!
        let document = CGPDFDocument(dataProvider)
        documentRepo.updateValue(document!, forKey: currentDocumentID)
        let pageCount = NSNumber(value: document!.numberOfPages)
        result(pageCount.stringValue);
    }
    
    private func closeDocument( call: FlutterMethodCall, result: @escaping FlutterResult)
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
        let document = self.documentRepo[documentID]!!
        let pageCount = NSNumber(value: document.numberOfPages)
        var pagesWidth = Array<Double>()
        for index in stride(from: 1,to: pageCount.intValue + 1, by: 1){
            let page = document.page(at: Int(index))
            var pageRect = page!.getBoxRect(.mediaBox)
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
        let document = self.documentRepo[documentID]!!
        let pageCount = NSNumber(value: document.numberOfPages)
        var pagesHeight = Array<Double>()
        for index in stride(from: 1,to: pageCount.intValue + 1, by: 1){
            let page = document.page(at: Int(index))
            var pageRect = page!.getBoxRect(.mediaBox)
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
        result(getImageForPlugin(index: index!,scale: scale,documentID: documentID))
    }
    
    // Gets the image for plugin
    private func getImageForPlugin(index: Int,scale: CGFloat,documentID: String) -> FlutterStandardTypedData
    {
        let document = self.documentRepo[documentID]!!
        let page = document.page(at: Int(index))
        var pageRect = page!.getBoxRect(.mediaBox)
        let imageRect = CGRect(x: 0,y: 0,width: pageRect.size.width*CGFloat(scale),height: pageRect.size.height*CGFloat(scale))
        let nsImage = NSImage(size: imageRect.size, actions: { cgContext in
            cgContext.beginPage(mediaBox: &pageRect)
            let transform = page!.getDrawingTransform(.mediaBox, rect: pageRect, rotate: 0, preserveAspectRatio: true)
            cgContext.translateBy(x: 0.0, y: imageRect.size.height)
            cgContext.scaleBy(x: CGFloat(scale), y: -CGFloat(scale))
            cgContext.concatenate(transform)
            cgContext.drawPDFPage(page!)
            cgContext.endPage()
        })
        let bytes = nsImage.tiffRepresentation?.bitmap?.png
        return bytes == nil ? FlutterStandardTypedData() : FlutterStandardTypedData(bytes: bytes!)
    }
}

extension NSBitmapImageRep {
    var png: Data? {
        return representation(using: .png, properties: [:])
    }
}

extension Data {
    var bitmap: NSBitmapImageRep? {
        return NSBitmapImageRep(data: self)
    }
}

extension NSImage {
    convenience init(size: CGSize, actions: (CGContext) -> Void) {
        self.init(size: size)
        lockFocusFlipped(true)
        actions(NSGraphicsContext.current!.cgContext)
        unlockFocus()
    }
    var png: Data? { tiffRepresentation?.bitmap?.png }
}
