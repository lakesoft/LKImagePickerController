#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = "LKImagePickerController"
  s.version          = "0.1.22"
  s.summary          = "A short description of LKImagePickerController."
  s.description      = <<-DESC
                       An optional longer description of LKImagePickerController

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "http://EXAMPLE/NAME"
  # s.screenshots      = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Hiroshi Hashiguchi" => "xcatsan@mac.com" }
  s.source           = { :git => "https://github.com/lakesoft/LKImagePickerController.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/EXAMPLE'

  # s.platform     = :ios, '5.0'
   s.ios.deployment_target = '8.1'
  # s.osx.deployment_target = '10.7'
  s.requires_arc = true

  s.source_files = 'Classes'
  s.resources = 'Resources/*.bundle'

  s.ios.exclude_files = 'Classes/osx'
  s.osx.exclude_files = 'Classes/ios'
  # s.public_header_files = 'Classes/**/*.h'
  s.frameworks = 'MediaPlayer'
  s.dependency 'LKAssetsLibrary', '~> 1.0'
end
