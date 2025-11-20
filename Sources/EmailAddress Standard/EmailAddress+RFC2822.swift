public import RFC_2822
import RFC_5322
import RFC_1123
import RFC_6531

// MARK: - EmailAddress ↔ RFC_2822.AddrSpec Conversions

extension EmailAddress {
    /// Initialize EmailAddress from RFC 2822 AddrSpec
    public init(_ addrSpec: RFC_2822.AddrSpec) throws {
        // RFC 2822 is obsoleted by RFC 5322, so we can treat the AddrSpec as RFC 5322 compatible
        try self.init(
            localPart: addrSpec.localPart,
            domain: addrSpec.domain
        )
    }
}

extension RFC_2822.AddrSpec {
    /// Initialize AddrSpec from EmailAddress
    public init(_ emailAddress: EmailAddress) throws {
        // Try to use RFC 5322 representation if available (most compatible)
        if let rfc5322 = emailAddress.rfc5322 {
            try self.init(
                localPart: String(describing: rfc5322.localPart),
                domain: rfc5322.domain.name
            )
        } else {
            // Fall back to RFC 6531 (most permissive)
            try self.init(
                localPart: String(describing: emailAddress.rfc6531.localPart),
                domain: emailAddress.rfc6531.domain.name
            )
        }
    }
}
