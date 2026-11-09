Pod::Spec.new do |s|
  s.name = 'TerraiOS'
  s.version = '2.2.0'
  s.summary = 'Terra mobile SDK for Apple Health, as a binary xcframework.'
  s.homepage = 'https://github.com/tryterra/TerraiOS'
  # The zip carries no LICENSE file, so the text travels in the spec.
  s.license = { :type => 'MIT', :text => <<~LICENSE }
    MIT License

    Copyright (c) 2022 TERRA

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
  LICENSE
  s.author = 'Terra'
  s.source = {
    :http => 'https://github.com/tryterra/TerraiOS/releases/download/2.2.0/TerraSDK.xcframework.zip',
    :sha256 => '87ce761af80dc874a5dc6ae6ab65945ab3e3f751756461017797faf3c7d308c5'
  }
  s.platform = :ios, '15.0'
  s.swift_versions = ['5.9', '6.0']
  s.vendored_frameworks = 'TerraSDK.xcframework'

end
