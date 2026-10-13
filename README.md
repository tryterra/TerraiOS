# TerraiOS

Terra's iOS SDK. It links a person's Apple Health to [Terra](https://tryterra.co), reads and writes
Health data, and uploads it to Terra on its own, in the foreground and in the background.

2.0.0 is a new major version, rebuilt from scratch. The module is now `TerraSDK`.

## Requirements

- iOS 15 or later
- Built with Xcode 26.6

## Install

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/tryterra/TerraiOS", from: "2.0.0"),
],
targets: [
    .target(name: "MyApp", dependencies: [.product(name: "TerraSDK", package: "TerraiOS")]),
    .testTarget(name: "MyAppTests", dependencies: [.product(name: "TerraTestKit", package: "TerraiOS")]),
]
```

In Xcode: File > Add Package Dependencies, enter `https://github.com/tryterra/TerraiOS`, choose
"Up to Next Major Version" from `2.0.0`, and add `TerraSDK` to your app target.

The `TerraiOS` product is the same binary as `TerraSDK`, kept so a 1.x dependency declaration still
resolves after the version bump. Use one of them, not both.

The package is binary only: SwiftPM downloads `TerraSDK.xcframework.zip` and
`TerraTestKit.xcframework.zip` from this repository's GitHub release and checks them against the
checksums in `Package.swift`.

### CocoaPods

```ruby
platform :ios, '15.0'

target 'MyApp' do
  pod 'TerraiOS', '~> 2.0'

  target 'MyAppTests' do
    pod 'TerraiOSTestKit', '~> 2.0'
  end
end
```

`TerraiOSTestKit` carries the TerraTestKit fakes; add it to test targets only. Both pods work with
and without `use_frameworks!` (static or dynamic linkage).

## Use

```swift
import TerraSDK

let terra = Terra(devID: "<your dev id>") { try await api.terraToken() }

try await terra.connect(.health)
try await terra.permissions.request(read: [.body])
let hr = try await terra.body.heartRate(in: .lastHours(1))
```

Call `BackgroundSync.register(terra: terra)` at launch. After that the SDK uploads on its own; there
is no sync call.

The host app needs:

- Entitlements: `com.apple.developer.healthkit`, `com.apple.developer.healthkit.access` (an empty
  array) and `com.apple.developer.healthkit.background-delivery`.
- `Info.plist`: `NSHealthShareUsageDescription`, `NSHealthUpdateUsageDescription` if the app writes,
  `UIBackgroundModes` with `fetch`, and `BGTaskSchedulerPermittedIdentifiers` with
  `co.tryterra.sdk.refresh`.

`TerraSDK.framework` carries its own privacy manifest (`PrivacyInfo.xcprivacy`), so Xcode's privacy
report includes it.

## Upgrading from 1.x

2.0.0 is a migration, not a drop-in upgrade: 1.x code does not compile against it.

- Change `import TerraiOS` to `import TerraSDK`.
- Raise your deployment target to iOS 15.
- Replace 1.x calls with the 2.x API. See the [migration guide](https://docs.tryterra.co).

An app on `from: "1.x"` (SwiftPM) or `~> 1.9` (CocoaPods) stays on 1.x until you change the
requirement. The 1.x tags are unchanged.

Full documentation: [docs.tryterra.co](https://docs.tryterra.co).
