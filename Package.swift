// swift-tools-version: 6.0
// This is a Skip (https://skip.tools) package.
import PackageDescription

let package = Package(
    name: "raven-rewards",
    defaultLocalization: "en",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "RavenRewards", type: .dynamic, targets: ["RavenRewards"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "1.6.7"),
        .package(url: "https://source.skip.tools/skip-fuse-ui.git", from: "1.0.0"),
        
        //My added packages
        .package(url: "https://github.com/twostraws/CodeScanner.git", from: "2.5.0"),
        .package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI.git",
                         from: "2.0.0"),
        .package(url: "https://github.com/skiptools/skip-firebase.git",
                 from: "0.11.0")
    ],
    targets: [
        .target(name: "RavenRewards", dependencies: [
            .product(name: "SkipFuseUI", package: "skip-fuse-ui"),
            
            //My added packages
            .product(name: "CodeScanner", package: "CodeScanner"),
            .product(name: "SDWebImageSwiftUI",
                     package: "SDWebImageSwiftUI",
                     condition: .when(platforms: [.iOS])),
            .product(name: "SkipFirebaseCore",       package: "skip-firebase"),
            .product(name: "SkipFirebaseAuth",       package: "skip-firebase"),
            .product(name: "SkipFirebaseFirestore",  package: "skip-firebase"),
            .product(name: "SkipFirebaseStorage",    package: "skip-firebase"),
            .product(name: "SkipFirebaseMessaging",  package: "skip-firebase"),
            .product(name: "SkipFirebaseAnalytics",  package: "skip-firebase")
        ], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
    ]
)
