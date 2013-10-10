
Pod::Spec.new do |s|
  s.name         = "AXRatingView"
  s.version      = "0.0.1"
  s.summary      = "A short description of AXRatingView."
  s.description  = <<-DESC
                   A longer description of AXRatingView in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC
  s.homepage     = "https://github.com/akiroom/AXRatingView"
  # s.screenshots  = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license      = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.author       = { "Hiroki Akiyama" => "aki-hiroki@nifty.com" }
  s.platform     = :ios

  s.source       = { :git => "https://github.com/akiroom/AXRatingView.git", :tag => "0.0.1" }
  s.source_files  = 'AXRatingView', 'Classes/**/*.{h,m}'
  s.framework  = 'QuartzCore'
  # s.frameworks = 'SomeFramework', 'AnotherFramework'
  s.requires_arc = true
end
