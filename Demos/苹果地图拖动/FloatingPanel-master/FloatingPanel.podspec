Pod::Spec.new do |s|

  s.name                = "FloatingPanel"
  s.version             = "1.4.0"
  s.summary             = "FloatingPanel is a clean and easy-to-use UI component of a floating panel interface."
  s.description         = <<-DESC
FloatingPanel is a clean and easy-to-use UI component for a new interface introduced in Apple Maps, Shortcuts and Stocks app.
The new interface displays the related contents and utilities in parallel as a user wants.
                   DESC
  s.homepage            = "https://github.com/SCENEE/FloatingPanel"
  # s.screenshots       = ""

  s.platform            = :ios, "10.0"
  s.source              = { :git => "https://github.com/SCENEE/FloatingPanel.git", :tag => "v#{s.version}" }
  s.source_files        = "Framework/Sources/*.swift"
  s.swift_version       = "4.0"
  s.pod_target_xcconfig = { 'SWIFT_WHOLE_MODULE_OPTIMIZATION' => 'YES', 'APPLICATION_EXTENSION_API_ONLY' => 'YES' }

  s.framework           = "UIKit"

  s.author              = { "Shin Yamamoto" => "shin@scenee.com" }
  s.license             = { :type => "MIT", :file => "LICENSE" }
  s.social_media_url    = "https://twitter.com/scenee"
end
