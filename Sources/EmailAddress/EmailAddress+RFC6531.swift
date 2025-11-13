import Foundation
import RFC_5321
import RFC_5322
import RFC_6531

extension EmailAddress {
    /// Initialize from RFC6531
    public init(rfc6531: RFC_6531.EmailAddress) {
        self.rfc5321 = try? RFC_5321.EmailAddress(rfc6531)
        self.rfc5322 = try? RFC_5322.EmailAddress(rfc6531)
        self.rfc6531 = rfc6531
        self.displayName = rfc6531.displayName
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
