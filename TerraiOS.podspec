Pod::Spec.new do |spec|
  spec.name           = "TerraiOS"
  spec.version        = "2.0.0"
  spec.summary        = "Terra's iOS SDK: Apple Health reads, writes and background uploads to Terra."
  spec.description    = <<-DESC
    TerraSDK connects an iOS app to Terra. It reads and writes Apple Health data and uploads it
    to Terra on its own, in the foreground and in the background. 2.x ships the TerraSDK module:
    `import TerraSDK`. Test doubles ship as the separate TerraiOSTestKit pod.
  DESC
  spec.homepage       = "https://github.com/tryterra/TerraiOS"
  spec.license        = { :type => "MIT", :text => "Copyright (c) 2022 TERRA. See https://github.com/tryterra/TerraiOS/blob/master/LICENSE" }
  spec.author         = { "Terra" => "dev@tryterra.co" }
  spec.platform       = :ios, "15.0"
  spec.source         = {
    :http => "https://github.com/tryterra/TerraiOS/releases/download/#{spec.version}/TerraSDK.xcframework.zip",
    :sha256 => "a7208210df5be248fc063acc69fdbbc2cbbc498560a52227b0c59a356dfecb18"
  }
  spec.swift_versions = ["5.9", "6.0"]
  spec.vendored_frameworks = "TerraSDK.xcframework"
end
