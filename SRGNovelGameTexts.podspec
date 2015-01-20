Pod::Spec.new do |s|
  s.name         = "SRGNovelGameTexts"
  s.version      = "0.0.1"
  s.summary      = "SRGNovelGameTexts is view parts that adds text like a novel game."
  s.homepage     = "https://github.com/kazu0620/SRGNovelGameTexts"
  s.license      = "MIT"
  s.author       = { "Kazuhiro Sakamoto" => "kazu620@gmail.com" }
  s.source       = { :git => "https://github.com/kazu0620/SRGNovelGameTexts.git", :tag => "0.0.1" }
  s.platform     = :ios, '7.0'
  s.source_files = "Classes", "Classes/**/*.{h,m}"
  s.requires_arc = true
end
