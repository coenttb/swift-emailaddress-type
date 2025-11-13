import Foundation
import RFC_5321
import RFC_5322
import RFC_6531

extension EmailAddress {
    /// Initialize from RFC5322
    public init(rfc5322: RFC_5322.EmailAddress) throws {
        self.rfc5321 = try? RFC_5321.EmailAddress(rfc5322)
        self.rfc5322 = rfc5322
        self.rfc6531 = try {
            guard
                let email = try? RFC_6531.EmailAddress(
                    displayName: rfc5322.displayName,
                    localPart: .init(rfc5322.localPart.stringValue),
                    domain: rfc5322.domain
                )
            else {
                throw EmailAddress.Error.conversionFailure
            }
            return email
        }()
        self.displayName = rfc5322.displayName
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
