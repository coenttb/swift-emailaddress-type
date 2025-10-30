# swift-emailaddress-type

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-macOS%2013%2B%20|%20iOS%2016%2B-lightgray.svg)]()
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![CI](https://github.com/coenttb/swift-emailaddress-type/workflows/CI/badge.svg)](https://github.com/coenttb/swift-emailaddress-type/actions/workflows/ci.yml)

Type-safe email address validation and parsing for Swift, supporting multiple RFC standards.

## Overview

`swift-emailaddress-type` provides a robust `EmailAddress` type that supports multiple RFC standards for email address formats:

- **RFC 5321**: SMTP email addresses (ASCII-only, strict format)
- **RFC 5322**: Internet Message Format addresses (ASCII with display names)
- **RFC 6531**: Internationalized email addresses (Unicode support)

The library automatically selects the most appropriate RFC format based on the input, while maintaining compatibility across all three standards.

## Features

- **Multi-RFC Support**: Seamlessly handles RFC 5321, 5322, and 6531 formats
- **Internationalization**: Full support for Unicode email addresses (RFC 6531)
- **Display Names**: Parse and format email addresses with display names
- **Type Safety**: Compile-time guarantees with Swift 6.0 strict concurrency
- **Validation**: Automatic validation against RFC standards
- **Codable**: Full JSON encoding/decoding support
- **Domain Support**: Integrated with `swift-domain-type` for proper domain handling

## Installation

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/coenttb/swift-emailaddress-type", from: "0.0.1")
]
```

## Quick Start

### Basic Email Addresses

```swift
import EmailAddress

// Simple email address
let email = try EmailAddress("john.doe@example.com")
print(email.address)     // "john.doe@example.com"
print(email.localPart)   // "john.doe"
print(email.domain.name) // "example.com"
```

### Email Addresses with Display Names

```swift
// Email with display name
let namedEmail = try EmailAddress("John Doe <john.doe@example.com>")
print(namedEmail.name)    // "John Doe"
print(namedEmail.address) // "john.doe@example.com"

// Display name with special characters
let quotedEmail = try EmailAddress("\"Doe, John\" <john.doe@example.com>")
print(quotedEmail.name) // "Doe, John"
```

### Component-Based Initialization

```swift
// Initialize with explicit display name
let email1 = try EmailAddress(
    displayName: "John Doe",
    "john.doe@example.com"
)

// Initialize with local part and domain
let email2 = try EmailAddress(
    localPart: "john.doe",
    domain: "example.com"
)
```

## Usage Examples

### Email Validation

```swift
// Validate email format
do {
    let email = try EmailAddress("john.doe@example.com")
    print("Valid email: \(email)")
} catch {
    print("Invalid email format")
}
```

### Working with Display Names

```swift
// Parse email with display name
let email = try EmailAddress("John Doe <john.doe@example.com>")
print(email.name)         // Optional("John Doe")
print(email.address)      // "john.doe@example.com"
print(email.stringValue)  // "John Doe <john.doe@example.com>"
```

### Special Characters and Quoted Local Parts

```swift
// Email with special characters in local part
let specialEmail = try EmailAddress(
    localPart: "test.!#$%&'*+-/=?^_`{|}~",
    domain: "example.com"
)

// Quoted local part
let quotedLocal = try EmailAddress(
    localPart: "\"john.doe\"",
    domain: "example.com"
)
```

### Subdomains

```swift
// Email with subdomain
let email = try EmailAddress("test@sub1.sub2.example.com")
print(email.domain.name) // "sub1.sub2.example.com"
```

### RFC Format Detection

```swift
let email = try EmailAddress("john.doe@example.com")

// Check if ASCII-only
print(email.isASCII)              // true
print(email.isInternationalized)  // false

// Access RFC-specific formats
if let rfc5321 = email.rfc5321 {
    print("RFC 5321 format available")
}
if let rfc5322 = email.rfc5322 {
    print("RFC 5322 format available")
}
```

### String Conversion

```swift
// Convert from string
let email = try "john.doe@example.com".asEmailAddress()

// Convert to string
let emailString = email.stringValue
let addressOnly = email.addressValue  // Without display name
```

### Codable Support

```swift
struct User: Codable {
    let name: String
    let email: EmailAddress
}

// Encoding
let user = User(
    name: "John Doe",
    email: try EmailAddress("john.doe@example.com")
)
let jsonData = try JSONEncoder().encode(user)

// Decoding
let decodedUser = try JSONDecoder().decode(User.self, from: jsonData)
```

### RawRepresentable

```swift
let email = try EmailAddress("john.doe@example.com")

// Get raw value
let rawValue = email.rawValue  // "john.doe@example.com"

// Initialize from raw value
let reconstructed = EmailAddress(rawValue: rawValue)
```

### Email Matching

```swift
let email1 = try EmailAddress("John Doe <john@example.com>")
let email2 = try EmailAddress("john@example.com")

// Match addresses (ignores display name)
if email1.matches(email2) {
    print("Same email address")
}
```

### Normalization

```swift
let email = try EmailAddress("John Doe <john@example.com>")

// Normalize to most restrictive format
let normalized = email.normalized()
```

### ASCII-Only Emails

```swift
// Enforce ASCII-only email
let asciiEmail = try EmailAddress.ascii("john@example.com")

// This would throw an error:
// let unicodeEmail = try EmailAddress.ascii("用户@example.com")
```

## Architecture

### EmailAddress Type

The `EmailAddress` struct maintains representations in all three RFC formats when possible:

```swift
public struct EmailAddress: Hashable, Sendable {
    let rfc5321: RFC_5321.EmailAddress?  // SMTP format (ASCII-only)
    let rfc5322: RFC_5322.EmailAddress?  // Message format (ASCII with names)
    let rfc6531: RFC_6531.EmailAddress   // International format (Unicode)

    public let displayName: String?
    public var name: String?
    public var address: String
    public var localPart: String
    public var domain: Domain
}
```

### RFC Standards

- **RFC 5321**: Strict SMTP format, ASCII-only, no display names in address
- **RFC 5322**: Internet Message Format, supports display names and comments
- **RFC 6531**: Internationalized email, supports Unicode characters

The library automatically determines which RFC formats are compatible with a given email address and maintains all compatible representations.

### Error Handling

```swift
public enum EmailAddressError: Error, Equatable, LocalizedError {
    case conversionFailure
    case invalidFormat(description: String)
}
```

### Protocol Conformances

- `Hashable`: Use in sets and as dictionary keys
- `Sendable`: Safe for concurrent access (Swift 6.0)
- `Codable`: JSON encoding/decoding
- `RawRepresentable`: String conversion
- `CustomStringConvertible`: Readable output

## Related Packages

- [swift-rfc-5321](https://github.com/swift-web-standards/swift-rfc-5321) - RFC 5321 SMTP email addresses
- [swift-rfc-5322](https://github.com/swift-web-standards/swift-rfc-5322) - RFC 5322 Internet Message Format
- [swift-rfc-6531](https://github.com/swift-web-standards/swift-rfc-6531) - RFC 6531 Internationalized email
- [swift-domain-type](https://github.com/coenttb/swift-domain-type) - Type-safe domain names

## Requirements

- Swift 6.0+
- macOS 13+ / iOS 16+

## License

This project is licensed under the Apache 2.0 License. See [LICENSE](LICENSE) for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Feedback

This package is part of the [coenttb](https://github.com/coenttb) suite of Swift server-side packages.

For issues, questions, or contributions, please visit the [GitHub repository](https://github.com/coenttb/swift-emailaddress-type).

- [Subscribe to newsletter](http://coenttb.com/en/newsletter/subscribe)
- [Follow on X](http://x.com/coenttb)
- [Connect on LinkedIn](https://www.linkedin.com/in/tenthijeboonkkamp)
