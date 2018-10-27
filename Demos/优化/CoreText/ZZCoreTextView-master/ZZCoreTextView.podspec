
Pod::Spec.new do |s|

  s.name         = "ZZCoreTextView"
  s.version      = "0.0.3"
  s.summary      = "ZZCoreTextView is a TextView to handle special strings such as url\tel\@someone"
  s.homepage     = "https://github.com/smalldu/ZZCoreTextView.git"
  s.license      = { :type => "MIT", :file => "LICENSE" } 
  s.author       = { "smalldu" => "363958265@qq.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/smalldu/ZZCoreTextView.git", :tag => s.version }
  s.source_files = "ZZCoreTextView/*.{swift,h,m}"
  s.requires_arc = true
  
end
