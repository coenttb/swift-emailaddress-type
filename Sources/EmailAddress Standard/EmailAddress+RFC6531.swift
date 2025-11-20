import RFC_5321
import RFC_5322
public import RFC_6531

extension EmailAddress {
    /// Initialize from RFC6531
    ///
    /// Stores an RFC 6531 (SMTPUTF8) email address directly as the canonical representation.
    /// This is the most efficient initialization since RFC 6531 is the canonical format.
    ///
    /// - Parameter rfc6531: The RFC 6531 email address to store
    public init(rfc6531: RFC_6531.EmailAddress) {
        // Store directly as canonical (RFC 6531 is the canonical format)
        self.init(canonical: rfc6531)
    }
}

extension RFC_6531.EmailAddress {
    /// Initialize from EmailAddress
    ///
    /// Enables round-trip conversion between EmailAddress and RFC_6531.EmailAddress.
    /// RFC 6531 is the most permissive format and supports internationalized email addresses.
    ///
    /// - Parameter emailAddress: The EmailAddress to convert
    public init(_ emailAddress: EmailAddress) {
        self = emailAddress.rfc6531
    }
}
