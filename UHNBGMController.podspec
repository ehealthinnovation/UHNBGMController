#
# Be sure to run `pod lib lint UHNBGMController.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "UHNBGMController"
  s.version          = "0.1.0"
  s.summary          = "A short description of UHNBGMController."
  s.description      = <<-DESC
                       An optional longer description of UHNBGMController

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/uhnmdi/UHNBGMController"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Nathaniel Hamming" => "nathaniel.hamming@gmail.com" }
  s.source           = { :git => "https://github.com/uhnmdi/UHNBGMController.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/NAteHAm80'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'UHNBGMController' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'CoreBluetooth'
  #s.dependency 'UHNBLEController'
end
