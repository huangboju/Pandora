import PackageDescription

let package = Package(
    name: "NetService-Example",
    dependencies: [
        .Package(url: "https://github.com/Bouke/NetService.git", majorVersion: 0, minor: 3)
    ]
)
