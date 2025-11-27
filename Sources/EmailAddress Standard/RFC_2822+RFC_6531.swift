// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-emailaddress-standard open source project
//
// Copyright (c) 2025 Coen ten Thije Boonkkamp
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
//
// SPDX-License-Identifier: Apache-2.0
//
// ===----------------------------------------------------------------------===//

public import RFC_2822
public import RFC_6531

// MARK: - RFC_2822.AddrSpec ← RFC_6531.EmailAddress

extension RFC_2822.AddrSpec {
    /// Initialize from RFC 6531 email address
    ///
    /// Converts an RFC 6531 (SMTPUTF8) internationalized email address to RFC 2822 addr-spec format.
    ///
    /// ## RFC Relationship
    ///
    /// RFC 6531 is a strict superset of RFC 2822:
    /// - RFC 2822 only allows ASCII characters (the `atext` character class)
    /// - RFC 6531 extends this with UTF-8 support
    ///
    /// Therefore, this conversion **requires validation** because a valid RFC 6531 address
    /// may contain characters that are invalid in RFC 2822.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // ASCII address - succeeds
    /// let rfc6531 = try RFC_6531.EmailAddress("user@example.com")
    /// let addrSpec = try RFC_2822.AddrSpec(rfc6531) // ✓
    ///
    /// // Internationalized address - fails
    /// let intl = try RFC_6531.EmailAddress("用户@例子.测试")
    /// let addrSpec = try RFC_2822.AddrSpec(intl) // ✗ throws
    /// ```
    ///
    /// - Parameter rfc6531: The RFC 6531 email address to convert
    /// - Throws: `RFC_2822.AddrSpec.Error` if the address contains non-ASCII characters
    ///           or patterns not allowed in RFC 2822
    public init(_ rfc6531: RFC_6531.EmailAddress) throws {
        // RFC 6531 ⊃ RFC 2822 (strict superset)
        // Must validate because RFC 6531 allows UTF-8 characters outside RFC 2822's grammar
        let combined = "\(rfc6531.localPart)@\(rfc6531.domain.name)"
        try self.init(ascii: combined.utf8)
    }
}

// MARK: - RFC_6531.EmailAddress ← RFC_2822.AddrSpec

extension RFC_6531.EmailAddress {
    /// Initialize from RFC 2822 addr-spec
    ///
    /// Converts an RFC 2822 addr-spec to RFC 6531 (SMTPUTF8) format.
    ///
    /// ## RFC Relationship
    ///
    /// RFC 6531 is a strict superset of RFC 2822:
    /// - Every valid RFC 2822 addr-spec is also valid RFC 6531
    /// - This conversion always succeeds for valid input
    ///
    /// ## Example
    ///
    /// ```swift
    /// let addrSpec = try RFC_2822.AddrSpec(ascii: "user@example.com".utf8)
    /// let rfc6531 = try RFC_6531.EmailAddress(addrSpec) // Always succeeds
    /// ```
    ///
    /// - Parameter addrSpec: The RFC 2822 addr-spec to convert
    /// - Throws: If the RFC 6531 validation fails (should not happen for valid RFC 2822 input)
    public init(_ addrSpec: RFC_2822.AddrSpec) throws {
        // RFC 2822 ⊂ RFC 6531 (strict subset)
        // A valid RFC 2822 addr-spec is always valid RFC 6531
        try self.init(
            displayName: nil,
            localPart: .init(addrSpec.localPart),
            domain: .init(addrSpec.domain)
        )
    }
}
