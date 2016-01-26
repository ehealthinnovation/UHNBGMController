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
  s.summary          = "A bluetooth glucose service collector."
  s.description      = <<-DESC
                       The bluetooth glucose service collector is built upon the UHNBLEControlelr, a general central BLE controller. The Glucose Collector provides a delegate based interface to interacting with Glucose service as defined by BT-SIG.

                       Read/Write/Notification interact with Glucose characterisitics
                       Procedures via record access control point
                       DESC
  s.homepage         = "https://github.com/uhnmdi/UHNBGMController"
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

  s.frameworks = 'CoreBluetooth'
  s.dependency 'UHNDebug'
  s.dependency 'UHNBLEController'
  
end
