Pod::Spec.new do |s|

  s.name = "UIWindowTransition"
  s.version = "1.2"
  
  s.summary      = "UIWindowTransition is easy way to animated set root view controller of UIWindow. It written in Swift 4.2"

  s.homepage     = "https://github.com/YuriFox/UIWindowTransition"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "YuriFox" => "yuri17fox@gmail.com" }
  s.source       = { :git => "https://github.com/YuriFox/UIWindowTransition.git", :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = "Source/*.swift"

end
