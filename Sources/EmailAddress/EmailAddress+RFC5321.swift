import Foundation
import RFC_5321
import RFC_5322
import RFC_6531

extension EmailAddress {
    /// Initialize from RFC5321
    public init(rfc5321: RFC_5321.EmailAddress) throws {
        self.rfc5321 = rfc5321
        self.rfc5322 = try? RFC_5322.EmailAddress(
            displayName: rfc5321.displayName,
            localPart: .init(rfc5321.localPart.stringValue),
            domain: .init(rfc5321.domain.name)
        )
        self.rfc6531 = try {
            guard
                let email = try? RFC_6531.EmailAddress(
                    displayName: rfc5321.displayName,
                    localPart: .init(rfc5321.localPart.stringValue),
                    domain: .init(rfc5321.domain.name)
                )
            else {
                throw EmailAddress.Error.conversionFailure
            }
            return email
        }()
        self.displayName = rfc5321.displayName
    }
}
