// swift-tools-version:6.1.2
import PackageDescription

enum Traits {
    static let SQLite = "SQLite"
    static let SQLCipher = "SQLCipher"
}

let package = Package(
    name: "fluent-sqlite-driver",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .watchOS(.v6),
        .tvOS(.v13),
    ],
    products: [
        .library(name: "FluentSQLiteDriver", targets: ["FluentSQLiteDriver"]),
    ],
    traits: [
        .trait(name: Traits.SQLite, description: "Enable SQLite without encryption"),
        .trait(name: Traits.SQLCipher, description: "Enable SQLCipher encryption support for encrypted databases"),
        .default(enabledTraits: [])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/fluent-kit.git", from: "1.51.0"),
        .package(url: "https://github.com/diokaratzas/sqlite-kit.git", branch: "feature/sql-cipher-2",  traits: [
            .trait(name: Traits.SQLite, condition: .when(traits: [Traits.SQLite])),
            .trait(name: Traits.SQLCipher, condition: .when(traits: [Traits.SQLCipher]))
        ]),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.6.3"),
    ],
    targets: [
        .target(
            name: "FluentSQLiteDriver",
            dependencies: [
                .product(name: "FluentKit", package: "fluent-kit"),
                .product(name: "FluentSQL", package: "fluent-kit"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "SQLiteKit", package: "sqlite-kit"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "FluentSQLiteDriverTests",
            dependencies: [
                .product(name: "FluentBenchmark", package: "fluent-kit"),
                .target(name: "FluentSQLiteDriver"),
            ],
            swiftSettings: swiftSettings
        ),
    ]
)

var swiftSettings: [SwiftSetting] { [
    .enableUpcomingFeature("ExistentialAny"),
    .enableUpcomingFeature("ConciseMagicFile"),
    .enableUpcomingFeature("ForwardTrailingClosures"),
    .enableUpcomingFeature("DisableOutwardActorInference"),
    .enableExperimentalFeature("StrictConcurrency=complete"),
] }
