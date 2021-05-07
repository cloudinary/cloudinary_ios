// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(name: "Cloudinary")

package.platforms = [
    .iOS(.v9),
    .tvOS(.v9),
    .macOS(.v10_12),
    .watchOS(.v3)
]
package.products = [
    .library(
        name: "Cloudinary",
        targets: ["Cloudinary-Core"]),
    .library(
        name: "Cloudinary-iOS",
        targets: ["Cloudinary-iOS"]),
]
package.targets = [
    .target(
        name: "Cloudinary-Core",
        dependencies: [],
        path: "Cloudinary/Classes/Core"),
    .target(
        name: "Cloudinary-iOS",
        dependencies: ["Cloudinary-Core"],
        path: "Cloudinary/Classes/iOS"
    )
]
package.swiftLanguageVersions = [
    .v5
]
