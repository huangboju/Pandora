Pod::Spec.new do |s|
  s.name         = "UIViewController+NavigationBar"
  s.version      = "0.3.3"
  s.summary      = "UIViewController with its own navigation bar."
  s.homepage     = "https://github.com/devxoul/UIViewController-NavigationBar"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "devxoul" => "devxoul@gmail.com" }
  s.source       = { :git => "https://github.com/devxoul/UIViewController-NavigationBar.git",
                     :tag => "#{s.version}" }
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source_files = 'Sources/*.{h,m}'
  s.frameworks   = 'Foundation', 'UIKit'
end
