import RFC_5321
import RFC_5322

extension RFC_5321.EmailAddress {
    /// Initialize from RFC 5322 email address
    ///
    /// Converts an RFC 5322 (Internet Message Format) email address to RFC 5321 (SMTP) format.
    /// RFC 5321 has more restrictive rules than RFC 5322.
    ///
    /// - Parameter rfc5322: The RFC 5322 email address to convert
    /// - Throws: If the address contains characters or patterns not allowed in RFC 5321
    public init(_ rfc5322: RFC_5322.EmailAddress) throws {
        try self.init(
            displayName: rfc5322.displayName,
            localPart: .init(String(describing: rfc5322.localPart)),
            domain: rfc5322.domain
        )
    }
}

extension RFC_5322.EmailAddress {
    /// Initialize from RFC 5321 email address
    ///
    /// Converts an RFC 5321 (SMTP) email address to RFC 5322 (Internet Message Format).
    /// RFC 5322 allows a superset of RFC 5321, so this conversion always succeeds.
    ///
    /// - Parameter rfc5321: The RFC 5321 email address to convert
    /// - Throws: If the local part cannot be represented in RFC 5322 format
    public init(_ rfc5321: RFC_5321.EmailAddress) throws {
        try self.init(
            displayName: rfc5321.displayName,
            localPart: .init(String(describing: rfc5321.localPart)),
            domain: rfc5321.domain
        )
    }
}
