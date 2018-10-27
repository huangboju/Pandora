Pod::Spec.new do |s|
  s.name                  = "BonjourSwift"
  s.version               = "1.1.0"
  s.summary               = "Easily access Bonjour services and domains in Swift"

  s.homepage              = "https://github.com/ecnepsnai/BonjourSwift"
  s.license               = 'MIT'
  s.author                = { 'Ian Spence' => 'ian@ecnepsnai.com' }
  s.social_media_url      = 'https://twitter.com/ecnepsnai'
  s.source                = { :git => "https://github.com/ecnepsnai/BonjourSwift.git", :tag => s.version.to_s }
  s.source_files          = 'Bonjour.swift'

  s.ios.deployment_target     = '8.0'
  s.tvos.deployment_target    = '9.0'

end
