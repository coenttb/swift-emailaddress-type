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
import RFC_5322
import RFC_6531

// MARK: - EmailAddress ← RFC_2822.AddrSpec

extension EmailAddress {
    /// Initialize EmailAddress from RFC 2822 AddrSpec
    ///
    /// RFC 2822 is obsoleted by RFC 5322, which has identical addr-spec syntax.
    /// The AddrSpec is converted to the canonical RFC 6531 representation.
    ///
    /// - Parameter addrSpec: The RFC 2822 addr-spec to convert
    /// - Throws: If the conversion to RFC 6531 fails
    public init(_ addrSpec: RFC_2822.AddrSpec) throws {
        // RFC 2822 → RFC 6531 (always succeeds, RFC 6531 is superset)
        let rfc6531 = try RFC_6531.EmailAddress(addrSpec)
        self.init(canonical: rfc6531)
    }
}

// MARK: - RFC_2822.AddrSpec ← EmailAddress

extension RFC_2822.AddrSpec {
    /// Initialize AddrSpec from EmailAddress
    ///
    /// Converts an EmailAddress to RFC 2822 addr-spec format.
    ///
    /// ## Conversion Strategy
    ///
    /// 1. **ASCII addresses (rfc5322 available)**: Uses `__unchecked` initialization
    ///    because RFC 5322 and RFC 2822 have identical addr-spec grammars.
    ///    Pre-validated RFC 5322 values are guaranteed valid RFC 2822.
    ///
    /// 2. **Internationalized addresses (rfc6531 only)**: Uses validating initialization
    ///    because RFC 6531 allows UTF-8 characters outside RFC 2822's grammar.
    ///    This will throw for non-ASCII addresses.
    ///
    /// - Parameter emailAddress: The EmailAddress to convert
    /// - Throws: `RFC_2822.AddrSpec.Error` if the address cannot be represented in RFC 2822
    public init(_ emailAddress: EmailAddress) throws {
        if let rfc5322 = emailAddress.rfc5322 {
            // RFC 5322 addr-spec syntax ≡ RFC 2822 addr-spec syntax
            // Pre-validated RFC 5322 values are guaranteed valid RFC 2822
            // Safe to use __unchecked
            self.init(
                __unchecked: (),
                localPart: String(describing: rfc5322.localPart),
                domain: rfc5322.domain.name
            )
        } else {
            // RFC 6531 ⊃ RFC 2822 (strict superset)
            // Must validate - uses dedicated RFC_2822.AddrSpec(RFC_6531.EmailAddress) initializer
            try self.init(emailAddress.rfc6531)
        }
    }
}
