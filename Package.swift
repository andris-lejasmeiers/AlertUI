// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "AlertUI",
  products: [
    .library(
      name: "AlertUI",
      targets: ["AlertUI"]
    ),
  ],
  targets: [
    .target(
      name: "AlertUI"
    )
  ]
)
