Pod::Spec.new do |s|
  s.name         = "HHCommonUtils"
  s.version      = "1.0.5"
  s.summary      = "developing utils."
  s.homepage     = "https://github.com/antiqueTung/HHCommonUtils"
  s.license      = "MIT"
  s.author             = { "AntiqueTung" => "13466818812@139.com" }
  s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/antiqueTung/HHCommonUtils.git", :tag => "#{s.version}" }
  s.source_files  = "HHCommonUtils/HHCommonUtils/*.{h,m}"
  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"
  s.requires_arc = true
end
