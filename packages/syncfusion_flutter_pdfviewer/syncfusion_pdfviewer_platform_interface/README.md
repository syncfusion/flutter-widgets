# Flutter PDF Viewer Platform Interface library

A common platform interface package for the [Syncfusion Flutter PDF Viewer](https://pub.dev/packages/syncfusion_flutter_pdfviewer) plugin.

This interface allows platform-specific implementations of the `syncfusion_flutter_pdfviewer`
plugin, as well as the plugin itself, to ensure they are supporting the
same interface.

# Usage

To implement a new platform-specific implementation of `syncfusion_flutter_pdfviewer`, extend
`PdfViewerPlatform` with an implementation that performs the
platform-specific behavior, and when you register your plugin, set the default
`PdfViewerPlatform` by calling
`PdfViewerPlatform.instance = SyncfusionFlutterPdfViewerPlugin()`.