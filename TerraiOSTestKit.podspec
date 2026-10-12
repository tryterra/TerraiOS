Pod::Spec.new do |spec|
  spec.name           = "TerraiOSTestKit"
  spec.version        = "2.0.0"
  spec.summary        = "Test doubles for Terra's iOS SDK (TerraTestKit), for test targets only."
  spec.description    = <<-DESC
    TerraTestKit fakes HealthKit, Terra's backend and storage, so an app can test its TerraSDK
    integration without a device or a network. Add it to test targets only.
  DESC
  spec.homepage       = "https://github.com/tryterra/TerraiOS"
  spec.license        = { :type => "MIT", :text => "Copyright (c) 2022 TERRA. See https://github.com/tryterra/TerraiOS/blob/master/LICENSE" }
  spec.author         = { "Terra" => "dev@tryterra.co" }
  spec.platform       = :ios, "15.0"
  spec.source         = {
    :http => "https://github.com/tryterra/TerraiOS/releases/download/#{spec.version}/TerraTestKit.xcframework.zip",
    :sha256 => "272a4709ce2aeaf2ae6824617cf8f61ce068f503b59af1665ba6efa7b64ead23"
  }
  spec.swift_versions = ["5.9", "6.0"]
  spec.vendored_frameworks = "TerraTestKit.xcframework"
  # TerraTestKit links TerraSDK and ships no copy of it; both come from one build.
  spec.dependency "TerraiOS", spec.version.to_s
end
