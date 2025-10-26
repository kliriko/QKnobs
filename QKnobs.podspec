Pod::Spec.new do |spec|
  spec.name         = "QKnobs"
  spec.version      = "0.0.1"
  spec.summary      = "QKnobs is a UI Framework that provides customizable UI components for music-related apps."
  spec.description  = <<-DESC
    QKnobs is a cross-platform UI framework that provides customizable and modern components such as knobs, faders, different EQ types and more,
    designed for audio and music-related applications. Supports macOS, iOS, and iPadOS.
  DESC
  
  spec.homepage     = "https://github.com/kliriko/QKnobs"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "klirik" => "wishreacher@gmail.com" }
  spec.source       = { :git => "https://github.com/kliriko/QKnobs.git", :tag => "#{spec.version}" }
  
  # Platform support
  spec.ios.deployment_target = '26.0'
  spec.osx.deployment_target = '26.0'
  
  # Swift version
  spec.swift_version = '5.0'
  
  # Source files
  spec.source_files = 'QKnobs/**/*.{h,m,swift}'
  
  # Frameworks
  spec.ios.frameworks = 'UIKit', 'CoreGraphics'
  spec.osx.frameworks = 'AppKit', 'CoreGraphics'
  
  spec.requires_arc = true
end