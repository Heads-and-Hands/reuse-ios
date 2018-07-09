Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '11.0'
s.name = "HeadsAndHandsKit"
s.summary = "HeadsAndHandsKit collects many useful methods"
s.requires_arc = true

s.version = "0.1.0"

s.license = { :type => "MIT", :file => "LICENSE" }

s.author = { "Sergey Gamayunov" => "sergey.gamayunov.87@gmail.com" }

s.homepage = "https://github.com/Heads-and-Hands/reuse-ios"

s.source = { :git => "https://github.com/Heads-and-Hands/reuse-ios", :tag => "#{s.version}"}

s.framework = "UIKit"

s.source_files = "HeadsAndHandsKit/**/*.{swift}"

s.resources = "HeadsAndHandsKit/**/*.{png,jpeg,jpg,storyboard,xib}"
end
