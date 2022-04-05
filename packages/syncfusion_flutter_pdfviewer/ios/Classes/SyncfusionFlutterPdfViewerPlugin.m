#import "SyncfusionFlutterPdfViewerPlugin.h"
#if __has_include(<syncfusion_flutter_pdfviewer/syncfusion_flutter_pdfviewer-Swift.h>)
#import <syncfusion_flutter_pdfviewer/syncfusion_flutter_pdfviewer-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "syncfusion_flutter_pdfviewer-Swift.h"
#endif

@implementation SyncfusionFlutterPdfViewerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSyncfusionFlutterPdfViewerPlugin registerWithRegistrar:registrar];
}
@end
