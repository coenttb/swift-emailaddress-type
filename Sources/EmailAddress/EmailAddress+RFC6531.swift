import Foundation
import RFC_5321
import RFC_5322
import RFC_6531

extension EmailAddress {
    /// Initialize from RFC6531
    public init(rfc6531: RFC_6531.EmailAddress) {
        self.rfc5321 = try? rfc6531.toRFC5321()
        self.rfc5322 = try? rfc6531.toRFC5322()
        self.rfc6531 = rfc6531
        self.displayName = rfc6531.displayName
    }
}
