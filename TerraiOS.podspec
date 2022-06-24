Pod::Spec.new do |spec|
    spec.name         = "TerraiOS"
    spec.version      = "1.0.10"
    spec.summary      = "iOS SDKs support for Terra"
    spec.description  = <<-DESC
                SDKs support for iOS to connect with Terra, including (but not limited to) Apple Health, Freestyle
                        DESC
    spec.homepage     = "https://docs.tryterra.co/reference/terra-ios-package"
    spec.license      = { :type => "MIT", :file => "LICENSE" }
    spec.author             = { "JaafarRammal" => "dev@tryterra.co" }
    spec.platform     = :ios
    spec.ios.deployment_target = "13.0"
    spec.source       = { :git => "https://github.com/tryterra/TerraiOS.git", :tag => "#{spec.version}"}
    spec.swift_version = "4.2"
    spec.vendored_frameworks = "TerraiOS.xcframework"  
end
