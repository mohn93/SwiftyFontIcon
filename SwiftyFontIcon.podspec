#
# Be sure to run `pod lib lint SwiftyFontIcon.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftyFontIcon'
  s.version          = '0.1.0'
  s.summary          = 'Use font icons in an readable and easy way.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
              Use font icons in an readable and easy way!
              FontAwesome and Google Design Icons Are Included.
                       DESC

  s.homepage         = 'https://github.com/mohn93/SwiftyFontIcon'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mohn93' => 'mohn93@gmail.com' }
  s.source           = { :git => 'https://github.com/mohn93/SwiftyFontIcon.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'SwiftyFontIcon/Classes/**/*'
  s.swift_versions = '4.0', '5.0'

   s.resource_bundles = {
     'SwiftyFontIcon' => ['SwiftyFontIcon/Assets/*.ttf']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
