// swift-tools-version:5.9
// TerraiOS 2.x ships the TerraSDK module (`import TerraSDK`). 1.x shipped the TerraiOS module from a
// committed xcframework; its tags are unchanged, so apps on `from: "1.x"` keep resolving to them.
// The 2.x binaries are attached to this repository's GitHub release for each version.
import PackageDescription

let package = Package(
    name: "TerraiOS",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "TerraSDK", targets: ["TerraSDK"]),
        // Kept under the 1.x product name, so an existing `.product(name: "TerraiOS", package: "TerraiOS")`
        // or Xcode package dependency resolves after the version bump. It is the same binary as `TerraSDK`.
        .library(name: "TerraiOS", targets: ["TerraSDK"]),
        // For test targets. A test that builds `Terra` from the fakes needs
        // `@_spi(Testing) import TerraSDK` as well, so the product carries both.
        .library(name: "TerraTestKit", targets: ["TerraTestKit", "TerraSDK"]),
    ],
    targets: [
        .binaryTarget(
            name: "TerraSDK",
            url: "https://github.com/tryterra/TerraiOS/releases/download/2.0.0/TerraSDK.xcframework.zip",
            checksum: "a7208210df5be248fc063acc69fdbbc2cbbc498560a52227b0c59a356dfecb18"
        ),
        .binaryTarget(
            name: "TerraTestKit",
            url: "https://github.com/tryterra/TerraiOS/releases/download/2.0.0/TerraTestKit.xcframework.zip",
            checksum: "272a4709ce2aeaf2ae6824617cf8f61ce068f503b59af1665ba6efa7b64ead23"
        ),
    ]
)
