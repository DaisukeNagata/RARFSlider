#
# Be sure to run `pod lib lint RARFSlider.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RARFSlider'
  s.version          = '0.6.1'
  s.summary          = 'RARFSlider is a video editing function.'
  s.homepage         = 'https://github.com/daisukenagata/RARFSlider'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'daisukenagata' => 'dbank0208@gmail.com' }
  s.source           = { :git => 'https://github.com/daisukenagata/RARFSlider.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/dbank0208'
  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'
  s.source_files = 'RARFSlider/Classes/**/*'
end
