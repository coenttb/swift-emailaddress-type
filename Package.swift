// swift-tools-version:6.2

import PackageDescription

extension String {
    static let emailAddress: Self = "EmailAddress Standard"
}

extension Target.Dependency {
    static var emailAddress: Self { .target(name: .emailAddress) }
}

extension Target.Dependency {
    static var rfc2822: Self { .product(name: "RFC 2822", package: "swift-rfc-2822") }
    static var rfc5321: Self { .product(name: "RFC 5321", package: "swift-rfc-5321") }
    static var rfc5322: Self { .product(name: "RFC 5322", package: "swift-rfc-5322") }
    static var rfc6531: Self { .product(name: "RFC 6531", package: "swift-rfc-6531") }
    static var domain: Self { .product(name: "Domain Standard", package: "swift-domain-standard") }
}

let package = Package(
    name: "swift-emailaddress-standard",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11)
    ],
    products: [
        .library(name: .emailAddress, targets: [.emailAddress])
    ],
    dependencies: [
        .package(url: "https://github.com/swift-standards/swift-rfc-2822", from: "0.1.0"),
        .package(url: "https://github.com/swift-standards/swift-rfc-5321", from: "0.1.0"),
        .package(url: "https://github.com/swift-standards/swift-rfc-5322", from: "0.1.0"),
        .package(url: "https://github.com/swift-standards/swift-rfc-6531", from: "0.1.0"),
        .package(url: "https://github.com/swift-standards/swift-domain-standard", from: "0.1.0")
    ],
    targets: [
        .target(
            name: .emailAddress,
            dependencies: [
                .domain,
                .rfc2822,
                .rfc5321,
                .rfc5322,
                .rfc6531
            ]
        ),
        .testTarget(
            name: .emailAddress.tests,
            dependencies: [
                .emailAddress
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)

extension String {
    var tests: Self {
        self + " Tests"
    }
}
