import Foundation
import RFC_5321
import RFC_5322
import RFC_6531

extension EmailAddress {
    /// Initialize from RFC5322
    public init(rfc5322: RFC_5322.EmailAddress) throws {
        self.rfc5321 = try? rfc5322.toRFC5321()
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
