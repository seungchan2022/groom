// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Architecture",
  platforms: [
    .iOS(.v17),
  ],
  products: [
    .library(
      name: "Architecture",
      targets: ["Architecture"]),
  ],
  dependencies: [
    .package(path: "../DesignSystem"),
    .package(path: "../Domain"),
    .package(path: "../Platform"),
    .package(path: "../Functor"),
    .package(
      url: "https://github.com/interactord/LinkNavigator",
      .upToNextMajor(from: "1.2.2")),
    .package(
      url: "https://github.com/pointfreeco/swift-composable-architecture",
      .upToNextMajor(from: "1.10.2")),
    .package(
      url: "https://github.com/apple/swift-log.git",
      .upToNextMajor(from: "1.5.3")),
    .package(
      url: "https://github.com/firebase/firebase-ios-sdk.git",
      .upToNextMajor(from: "10.26.0")),
  ],
  targets: [
    .target(
      name: "Architecture",
      dependencies: [
        "DesignSystem",
        "Domain",
        "Platform",
        "Functor",
        "LinkNavigator",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "Logging", package: "swift-log"),
        .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
        .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
        .product(name: "FirebaseFirestoreSwift", package: "firebase-ios-sdk"),
      ]),
    .testTarget(
      name: "ArchitectureTests",
      dependencies: ["Architecture"]),
  ])
