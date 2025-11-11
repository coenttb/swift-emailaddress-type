// swift-tools-version:6.0

import Foundation
import PackageDescription

extension String {
    static let emailAddress: Self = "EmailAddress"
}

extension Target.Dependency {
    static var emailAddress: Self { .target(name: .emailAddress) }
}

extension Target.Dependency {
    static var rfc2822: Self { .product(name: "RFC_2822", package: "swift-rfc-2822") }
    static var rfc5321: Self { .product(name: "RFC_5321", package: "swift-rfc-5321") }
    static var rfc5322: Self { .product(name: "RFC_5322", package: "swift-rfc-5322") }
    static var rfc6531: Self { .product(name: "RFC_6531", package: "swift-rfc-6531") }
    static var domain: Self { .product(name: "Domain", package: "swift-domain-type") }
}

let package = Package(
    name: "swift-emailaddress-type",
    platforms: [ .macOS(.v13), .iOS(.v16) ],
    products: [
        .library(name: .emailAddress, targets: [.emailAddress])
    ],
    dependencies: [
        .package(url: "https://github.com/swift-web-standards/swift-rfc-2822", from: "0.0.1"),
        .package(url: "https://github.com/swift-web-standards/swift-rfc-5321", from: "0.0.1"),
        .package(url: "https://github.com/swift-web-standards/swift-rfc-5322", from: "0.0.1"),
        .package(url: "https://github.com/swift-web-standards/swift-rfc-6531", from: "0.0.1"),
        .package(url: "https://github.com/coenttb/swift-domain-type", from: "0.0.1")
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
