#
# Be sure to run `pod lib lint Highlightr.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Highlightr3"
  s.version          = "3.0.2"
  s.summary          = "iOS & macOS Syntax Highlighter."

  s.description      = <<-DESC
                    Highlightr is an iOS & macOS syntax highlighter built with Swift. It uses highlight.js as it core, supports 176 languages and comes with 79 styles.
                       DESC

  s.homepage         = "http://github.com/raspu/Highlightr"
  s.screenshots     = "http://raw.githubusercontent.com/octree/Highlightr/master/coding.gif"
  s.license          = 'MIT'
  s.author           = { "J.P. Illanes" => "jpillaness@gmail.com" }
  s.source           = { :git => "https://github.com/octree/Highlightr.git", :tag => s.version.to_s, :submodules => true}

  s.osx.deployment_target = '10.11'
  s.ios.deployment_target = '10.0'

  s.swift_version = '5.3'

  s.requires_arc = true

  s.source_files = 'Sources/Highlightr/**/*.{swift}'

  s.resources  = 'Sources/Highlightr/Resources/**/*.{css,js}'

  s.ios.frameworks = 'UIKit'
  s.osx.frameworks = 'AppKit'
end





