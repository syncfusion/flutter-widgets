#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint syncfusion_flutter_pdfviewer.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'syncfusion_flutter_pdfviewer'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage = 'https://github.com/syncfusion/flutter-widgets/tree/master/packages/syncfusion_flutter_pdfviewer'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'syncfusion_flutter_pdfviewer/Sources/syncfusion_flutter_pdfviewer/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
