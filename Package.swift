// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "perros",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        
        // 🔵 Swift ORM (queries, models, relations, etc) built on MySQL 3.
        .package(url: "https://github.com/vapor/fluent-mysql.git", from: "3.0.0"),
        
        // 👤 Authentication and Authorization layer for Fluent.
        .package(url: "https://github.com/vapor/auth.git", from: "2.0.0"),
        
        .package(url: "https://github.com/vapor-community/pagination.git", from: "1.0.0"),
        
        .package(url: "https://github.com/twof/VaporMailgunService.git", from: "3.0.0"),
        
        .package(url: "https://github.com/vapor-community/vapor-ext.git", from: "0.1.0"),
    ],
    targets: [
        .target(name: "App", dependencies: ["Authentication", "FluentMySQL", "Vapor", "Pagination", "Mailgun", "VaporExt"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

