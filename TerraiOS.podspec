Pod::Spec.new do |s|
  s.name = 'TerraiOS'
  s.version = '2.0.0'
  s.summary = 'Terra mobile SDK for Apple Health, as a binary xcframework.'
  s.homepage = 'https://github.com/tryterra/TerraiOS'
  s.license = { :type => 'Proprietary', :text => 'Copyright Terra' }
  s.author = 'Terra'
  s.source = {
    :http => 'https://github.com/tryterra/TerraiOS/releases/download/2.0.0/TerraSDK.xcframework.zip',
    :sha256 => '1a4c0cea5e4b9e30be81d0f115915f24edd2df9f78b57c0b0caf2aed6cc85970'
  }
  s.platform = :ios, '15.0'
  s.swift_versions = ['5.9', '6.0']
  s.vendored_frameworks = 'TerraSDK.xcframework'

end
