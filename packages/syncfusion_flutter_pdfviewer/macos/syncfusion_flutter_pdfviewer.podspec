#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint syncfusion_flutter_pdfviewer.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'syncfusion_flutter_pdfviewer'
  s.version          = '0.0.1'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'https://github.com/syncfusion/flutter-widgets/tree/master/packages/syncfusion_flutter_pdfviewer'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
