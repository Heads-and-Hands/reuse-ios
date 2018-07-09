Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '11.0'
s.name = "HeadsAndHandsKit"
s.summary = "HeadsAndHandsKit collects many useful methods"
s.requires_arc = true
s.license = { :type => 'MIT', :text => <<-LICENSE
                   Copyright 2012
                   Permission is granted to...
                 LICENSE
               }

s.version = "0.1.0"

s.author = { "Sergey Gamayunov" => "sergey.gamayunov.87@gmail.com" }

s.homepage = "https://github.com/Heads-and-Hands/reuse-ios"

s.source = { :git => "https://github.com/Heads-and-Hands/reuse-ios.git", :tag => "0.1.0" }

s.framework = "UIKit"

s.source_files = "HeadsAndHandsKit/**/*.{swift}"

s.swift_version = "4.1"

end
