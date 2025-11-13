import Foundation
import RFC_5321
import RFC_5322
import RFC_6531

extension EmailAddress {
    /// Initialize from RFC5322
    ///
    /// Converts an RFC 5322 (Internet Message Format) email address to the EmailAddress type
    /// by storing it as the canonical RFC 6531 format internally.
    ///
    /// - Parameter rfc5322: The RFC 5322 email address to convert
    /// - Throws: If the conversion to RFC 6531 fails
    public init(rfc5322: RFC_5322.EmailAddress) throws {
        // Convert to RFC 6531 and store as canonical
        let rfc6531 = try RFC_6531.EmailAddress(rfc5322)
        self.init(canonical: rfc6531)
    }
}

extension RFC_5322.EmailAddress {
    /// Initialize from EmailAddress
    ///
    /// Enables round-trip conversion between EmailAddress and RFC_5322.EmailAddress.
    /// This is particularly useful when converting Email objects to RFC 5322 Message format.
    ///
    /// - Parameter emailAddress: The EmailAddress to convert
    /// - Throws: If the EmailAddress doesn't have a valid RFC 5322 representation
    public init(_ emailAddress: EmailAddress) throws {
        guard let rfc5322 = emailAddress.rfc5322 else {
            throw EmailAddress.Error.conversionFailure
        }
        self = rfc5322
    }
}
