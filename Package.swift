// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "purine-guardian",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),

        // 🔵 Swift ORM (queries, models, relations, etc) built on SQLite 3.
        .package(url: "https://github.com/vapor/fluent-sqlite.git", from: "3.0.0"),
        
        // Mongo Db
        .package(url: "https://github.com/mongodb/mongo-swift-driver.git", from: "0.0.7")
    ],
    targets: [
        .target(name: "App", dependencies: ["MongoSwift", "Vapor"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

