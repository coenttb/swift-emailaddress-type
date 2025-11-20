//
//  File.swift
//  swift-web
//
//  Created by Coen ten Thije Boonkkamp on 28/12/2024.
//

public import Domain_Standard
public import RFC_5321
public import RFC_5322
public import RFC_6531

/// An email address that can be represented according to different RFC standards
///
/// Internally stores a single canonical RFC 6531 representation (most permissive format).
/// Other RFC variants (5321, 5322) are computed on-demand when accessed.
public struct EmailAddress: Hashable, Sendable {
    /// The canonical RFC 6531 representation
    private let canonical: RFC_6531.EmailAddress
    
    /// Internal initializer that directly stores the canonical RFC 6531 representation
    /// Used by conversion initializers in EmailAddress+RFC*.swift files
    internal init(canonical: RFC_6531.EmailAddress) {
        self.canonical = canonical
    }
    
    /// Initialize with an email address string
    public init(
        displayName: String? = nil,
        _ string: String
    ) throws {
        // Parse as RFC 6531 (most permissive format)
        let rfc6531Address = try RFC_6531.EmailAddress(string)
        
        // Store canonical form with optional display name override
        if let displayName = displayName {
            self.canonical = RFC_6531.EmailAddress(
                displayName: displayName,
                localPart: rfc6531Address.localPart,
                domain: rfc6531Address.domain
            )
        } else {
            self.canonical = rfc6531Address
        }
    }
}

extension EmailAddress_Standard.EmailAddress {
    /// Initialize with components
    public init(displayName: String? = nil, localPart: String, domain: String) throws {
        try self.init(
            displayName: displayName,
            "\(localPart)@\(domain)"
        )
    }
}

extension EmailAddress_Standard.EmailAddress {
    
    public var name: String? { displayName }
    
    /// The display name associated with this email address, if any
    public var displayName: String? { canonical.displayName }
    
}

extension EmailAddress_Standard.EmailAddress {
    
    /// RFC 5321 (SMTP) representation, if the address is ASCII-only
    public var rfc5321: RFC_5321.EmailAddress? {
        guard canonical.isASCII else { return nil }
        return try? RFC_5321.EmailAddress(canonical)
    }
    
    /// RFC 5322 (Internet Message Format) representation, if the address is ASCII-only
    public var rfc5322: RFC_5322.EmailAddress? {
        guard canonical.isASCII else { return nil }
        return try? RFC_5322.EmailAddress(canonical)
    }
    
    /// RFC 6531 (SMTPUTF8) representation - always available
    public var rfc6531: RFC_6531.EmailAddress { canonical }
    
}

// MARK: - Properties
extension EmailAddress {
    /// The email address string without display name
    public var address: String {
        rfc5321?.address ?? rfc5322?.address ?? rfc6531.address
    }
    
    /// The local part (before @)
    public var localPart: String {
        if let rfc5321 = rfc5321 {
            return String(describing: rfc5321.localPart)
        }
        if let rfc5322 = rfc5322 {
            return String(describing: rfc5322.localPart)
        }
        return String(describing: rfc6531.localPart)
    }
}

extension EmailAddress {
    /// The domain part (after @)
    ///
    /// - Note: Uses `try!` for RFC format conversions because EmailAddress initialization
    ///   ensures all RFC variants contain valid, compatible domains. Converting from an already-validated
    ///   RFC 5322 or RFC 6531 domain to RFC 1123 format cannot fail since validation occurred during init.
    public var domain: Domain_Standard.Domain {
        if let emailAddress = rfc5321 {
            return Domain_Standard.Domain(rfc1123: emailAddress.domain)
        }
        if let emailAddress = rfc5322 {
            // Safe: RFC 5322 domain was validated during EmailAddress init
            return Domain_Standard.Domain(rfc1123: emailAddress.domain)
        }
        // Safe: RFC 6531 domain was validated during EmailAddress init
        return Domain_Standard.Domain(rfc1123: rfc6531.domain)
    }
    
    /// Returns true if this is an ASCII-only email address
    public var isASCII: Bool {
        rfc5321 != nil || rfc5322 != nil
    }
    
    /// Returns true if this is an internationalized email address
    public var isInternationalized: Bool {
        !isASCII
    }
}

// MARK: - Email Operations
extension EmailAddress {
    /// Returns a normalized version of the email address
    /// - For ASCII addresses, uses the most restrictive format available (5321 > 5322 > 6531)
    /// - For international addresses, uses RFC 6531
    ///
    /// - Note: Uses `try!` when reconstructing EmailAddress from already-validated RFC formats.
    ///   Since these RFC variants were validated during the original EmailAddress initialization,
    ///   recreating an EmailAddress from them is guaranteed to succeed.
    public func normalized() -> EmailAddress {
        // Already normalized if we only have RFC 6531
        guard isASCII else { return self }
        
        // Use most restrictive format available
        if let rfc5321 = self.rfc5321 {
            // Safe: Reconstructing from already-validated RFC 5321 format
            return try! EmailAddress(rfc5321: rfc5321)
        }
        if let rfc5322 = self.rfc5322 {
            // Safe: Reconstructing from already-validated RFC 5322 format
            return try! EmailAddress(rfc5322: rfc5322)
        }
        return self
    }
    
    /// Returns true if this email address matches another under the same RFC
    /// - Attempts to compare using the most restrictive common format
    /// - Display names are not considered in the match
    public func matches(_ other: EmailAddress) -> Bool {
        if let myRFC5321 = rfc5321, let otherRFC5321 = other.rfc5321 {
            return myRFC5321.address.lowercased() == otherRFC5321.address.lowercased()
        }
        if let myRFC5322 = rfc5322, let otherRFC5322 = other.rfc5322 {
            return myRFC5322.address.lowercased() == otherRFC5322.address.lowercased()
        }
        return rfc6531.address.lowercased() == other.rfc6531.address.lowercased()
    }
}

// MARK: - Errors
extension EmailAddress {
    public enum Error: Swift.Error, Equatable {
        case conversionFailure
        case invalidFormat(description: String)
        
        public var errorDescription: String? {
            switch self {
            case .conversionFailure:
                return "Failed to convert between email address formats"
            case .invalidFormat(let description):
                return "Invalid email format: \(description)"
            }
        }
    }
}

// MARK: - Protocol Conformances
extension EmailAddress: CustomStringConvertible {
    public var description: String { String(self) }
}

extension EmailAddress: Codable {
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        try self.init(rawValue)
    }
}

extension EmailAddress: RawRepresentable {
    public var rawValue: String { String(self) }
    public init?(rawValue: String) { try? self.init(rawValue) }
}

// Could add convenience initializer for common case
extension EmailAddress {
    public init (ascii string: String) throws  {
        let email = try Self(string)
        guard email.isASCII else {
            throw Error.invalidFormat(description: "Must be ASCII-only")
        }
        self = email
    }
}

extension EmailAddress {
    /// A non-RFC5322 compliant regex for simple validation scenarios
    public static let regex: String =
    "^(?!.*\\.\\.)[A-Za-z0-9](?:[A-Za-z0-9._%+-]{0,62}[A-Za-z0-9])?@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
}
