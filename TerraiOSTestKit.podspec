Pod::Spec.new do |s|
  s.name = 'TerraiOSTestKit'
  s.version = '2.0.0'
  s.summary = 'Test doubles for the Terra mobile SDK, as a binary xcframework.'
  s.homepage = 'https://github.com/tryterra/TerraiOS'
  s.license = { :type => 'Proprietary', :text => 'Copyright Terra' }
  s.author = 'Terra'
  s.source = {
    :http => 'https://github.com/tryterra/TerraiOS/releases/download/2.0.0/TerraTestKit.xcframework.zip',
    :sha256 => 'e8a32c2858e5229286b34a4f8792d4e86022630c026a3519c9196530a545d664'
  }
  s.platform = :ios, '15.0'
  s.swift_versions = ['5.9', '6.0']
  s.vendored_frameworks = 'TerraTestKit.xcframework'
  s.dependency 'TerraiOS', '2.0.0'
end
