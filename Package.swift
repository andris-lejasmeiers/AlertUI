// swift-tools-version: 5.8

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
