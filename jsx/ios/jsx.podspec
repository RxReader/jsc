#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint jsx.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'jsx'
  s.version          = '0.0.1'
  s.summary          = 'Flutter plugin for jsc.'
  s.description      = <<-DESC
Flutter plugin for jsc.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  s.subspec 'vendor' do |sp|
    sp.frameworks = 'JavaScriptCore'
  end

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
