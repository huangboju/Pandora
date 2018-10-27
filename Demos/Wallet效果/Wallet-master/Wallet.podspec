Pod::Spec.new do |s|
  s.name             = 'Wallet'
  s.version          = '1.4.1'
  s.summary          = 'Wallet is a library to manage cards and passes.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Wallet is a replica of the Apple's Wallet interface. Add, delete or present your cards and passes.
                       DESC

  s.homepage         = 'https://github.com/rshevchuk/Wallet'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'Ruslan Shevchuk' => 'inbox@rshevchuk.io' }
  s.source           = { :git => 'https://github.com/rshevchuk/Wallet.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'Wallet/Classes/**/*'

  # s.resource_bundles = {
  #   'Wallet' => ['Wallet/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
