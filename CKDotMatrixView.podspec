
Pod::Spec.new do |s|

  s.name         = "CKDotMatrixView"
  s.version      = "0.1.2"
  s.summary      = "A highly customizable animated banner-like dot matrix view."

  s.description  = <<-DESC
                   CKDotMatrixView provides a retro-style dot matrix that displays
                   numbers or text. It is completely configured via storyboard. Use
                   it just like you would place text on a label programmatically.
                   DESC

  s.homepage     = "https://github.com/JaNd3r/CKDotMatrixView"
  s.screenshots  = "https://raw.githubusercontent.com/JaNd3r/CKDotMatrixView/master/DotMatrixDemo1.gif"

  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Christian Klaproth" => "ck@cm-works.de" }
  s.social_media_url   = "http://twitter.com/JaNd3r"

  s.platform     = :ios, "8.1"
  s.requires_arc = true

  s.source       = { :git => "https://github.com/JaNd3r/CKDotMatrixView.git", :tag => "0.1.2" }

  s.source_files  = "CKDotMatrixView/*.{h,m}"

end
