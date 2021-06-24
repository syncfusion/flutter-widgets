import Cocoa
import FlutterMacOS
import CoreGraphics
import Foundation
import AppKit

public class SyncfusionFlutterPdfViewerPlugin: NSObject, FlutterPlugin {

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

    // Gets the image for plugin
    private func getImageForPlugin(index: Int) -> FlutterStandardTypedData
    {
        if(self.document != nil)
            {
                let page = self.document!.page(at: Int(index))
                var pageRect = page!.getBoxRect(.mediaBox)
                let imageRect = CGRect(x: 0,y: 0,width: pageRect.size.width*2,height: pageRect.size.height*2)
                let nsImage = NSImage(size: imageRect.size, actions: { cgContext in
                        cgContext.beginPage(mediaBox: &pageRect)
                        let transform = page!.getDrawingTransform(.mediaBox, rect: pageRect, rotate: 0, preserveAspectRatio: true)
                        cgContext.translateBy(x: 0.0, y: imageRect.size.height)
                        cgContext.scaleBy(x: 2, y: -2)
                        cgContext.concatenate(transform)
                        cgContext.drawPDFPage(page!)
                        cgContext.endPage()
                    })
                let bytes = nsImage.tiffRepresentation?.bitmap?.png
                return FlutterStandardTypedData(bytes: bytes!)
            }
        return FlutterStandardTypedData()
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
