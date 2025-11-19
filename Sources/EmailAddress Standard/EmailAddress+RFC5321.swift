import RFC_5321
import RFC_5322
import RFC_6531

extension EmailAddress {
    /// Initialize from RFC5321
    ///
    /// Converts an RFC 5321 (SMTP) email address to the EmailAddress type by storing
    /// it as the canonical RFC 6531 format internally.
    ///
    /// - Parameter rfc5321: The RFC 5321 email address to convert
    /// - Throws: If the conversion to RFC 6531 fails
    public init(rfc5321: RFC_5321.EmailAddress) throws {
        // Convert to RFC 6531 and store as canonical
        let rfc6531 = try RFC_6531.EmailAddress(rfc5321)
        self.init(canonical: rfc6531)
    }
}

extension RFC_5321.EmailAddress {
    /// Initialize from EmailAddress
    ///
    /// Enables round-trip conversion between EmailAddress and RFC_5321.EmailAddress.
    ///
    /// - Parameter emailAddress: The EmailAddress to convert
    /// - Throws: If the EmailAddress doesn't have a valid RFC 5321 representation
    public init(_ emailAddress: EmailAddress) throws {
        guard let rfc5321 = emailAddress.rfc5321 else {
            throw EmailAddress.Error.conversionFailure
        }
        self = rfc5321
    }
}
