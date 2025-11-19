import RFC_1123
import RFC_5321
import RFC_6531

extension RFC_5321.EmailAddress {
    /// Initialize from RFC 6531 email address
    ///
    /// Converts an RFC 6531 (SMTPUTF8) internationalized email address to RFC 5321 (SMTP) format.
    /// Only works for addresses that use ASCII characters only.
    ///
    /// - Parameter rfc6531: The RFC 6531 email address to convert
    /// - Throws: If the address contains non-ASCII characters or patterns not allowed in RFC 5321
    public init(_ rfc6531: RFC_6531.EmailAddress) throws {
        try self.init(
            displayName: rfc6531.displayName,
            localPart: .init(String(describing: rfc6531.localPart)),
            domain: .init(rfc6531.domain.name)
        )
    }
}

extension RFC_6531.EmailAddress {
    /// Initialize from RFC 5321 email address
    ///
    /// Converts an RFC 5321 (SMTP) email address to RFC 6531 (SMTPUTF8) format.
    /// RFC 6531 is a superset of RFC 5321, so this conversion always succeeds.
    ///
    /// - Parameter rfc5321: The RFC 5321 email address to convert
    /// - Throws: If the conversion fails
    public init(_ rfc5321: RFC_5321.EmailAddress) throws {
        try self.init(
            displayName: rfc5321.displayName,
            localPart: .init(String(describing: rfc5321.localPart)),
            domain: rfc5321.domain
        )
    }
}
