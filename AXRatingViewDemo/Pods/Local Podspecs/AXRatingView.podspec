
Pod::Spec.new do |s|
  s.name         = "AXRatingView"
  s.version      = "0.91"
  s.summary      = "Star mark rating view"
  s.description  = <<-DESC
                   Star mark rating view for a review scene.
                   - analog star (like 4.23)
                   - digital star (like 4.00)
                   - inherihence from UIControl
                   DESC
  s.homepage     = "https://github.com/akiroom/AXRatingView"
  s.screenshots  = "raw.github.com/akiroom/AXRatingView/master/AXRatingViewDemo/Screenshot.png"
  s.license      = { :type => 'MIT', :file => 'README.md' }
  s.author       = { "Hiroki Akiyama" => "aki-hiroki@nifty.com" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/akiroom/AXRatingView.git", :tag => "0.91" }
  s.source_files  = 'AXRatingView', 'Classes/**/*.{h,m}'
  s.framework  = 'QuartzCore'
  s.requires_arc = true
end
