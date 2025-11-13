import Foundation
import RFC_5322
import RFC_6531

extension RFC_5322.EmailAddress {
    /// Initialize from RFC 6531 email address
    ///
    /// Converts an RFC 6531 (SMTPUTF8) internationalized email address to RFC 5322 (Internet Message Format).
    /// Only works for addresses that use ASCII characters only.
    ///
    /// - Parameter rfc6531: The RFC 6531 email address to convert
    /// - Throws: If the address contains non-ASCII characters or patterns not allowed in RFC 5322
    public init(_ rfc6531: RFC_6531.EmailAddress) throws {
        try self.init(
            displayName: rfc6531.displayName,
            localPart: .init(rfc6531.localPart.description),
            domain: rfc6531.domain
        )
    }
}

extension RFC_6531.EmailAddress {
    /// Initialize from RFC 5322 email address
    ///
    /// Converts an RFC 5322 (Internet Message Format) email address to RFC 6531 (SMTPUTF8) format.
    /// RFC 6531 is a superset of RFC 5322, so this conversion always succeeds.
    ///
    /// - Parameter rfc5322: The RFC 5322 email address to convert
    /// - Throws: If the conversion fails
    public init(_ rfc5322: RFC_5322.EmailAddress) throws {
        try self.init(
            displayName: rfc5322.displayName,
            localPart: .init(rfc5322.localPart.description),
            domain: rfc5322.domain
        )
    }
}
