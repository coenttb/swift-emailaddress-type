//
//  ReadmeVerificationTests.swift
//  swift-emailaddress-standard
//
//  Validates all code examples from README.md
//

import Foundation
import Testing
@testable import EmailAddress_Standard

@Suite("README Code Examples Validation", .serialized)
struct ReadmeVerificationTests {

    @Test
    func `Quick Start - Basic Email Addresses (README lines 43-51)`() throws {
        // Simple email address
        let email = try EmailAddress("john.doe@example.com")
        #expect(email.address == "john.doe@example.com")
        #expect(email.localPart == "john.doe")
        #expect(email.domain.name == "example.com")
    }

    @Test
    func `Quick Start - Email Addresses with Display Names (README lines 56-64)`() throws {
        // Email with display name
        let namedEmail = try EmailAddress("John Doe <john.doe@example.com>")
        #expect(namedEmail.name == "John Doe")
        #expect(namedEmail.address == "john.doe@example.com")

        // Display name with special characters
        let quotedEmail = try EmailAddress("\"Doe, John\" <john.doe@example.com>")
        #expect(quotedEmail.name == "Doe, John")
    }

    @Test
    func `Quick Start - Component-Based Initialization (README lines 69-80)`() throws {
        // Initialize with explicit display name
        let email1 = try EmailAddress(
            displayName: "John Doe",
            "john.doe@example.com"
        )
        #expect(email1.name == "John Doe")
        #expect(email1.address == "john.doe@example.com")

        // Initialize with local part and domain
        let email2 = try EmailAddress(
            localPart: "john.doe",
            domain: "example.com"
        )
        #expect(email2.localPart == "john.doe")
        #expect(email2.domain.name == "example.com")
    }

    @Test
    func `Email Validation (README lines 87-94)`() throws {
        // Validate email format
        do {
            let email = try EmailAddress("john.doe@example.com")
            #expect(email.address == "john.doe@example.com")
        } catch {
            Issue.record("Email validation should succeed")
        }
    }

    @Test
    func `Working with Display Names (README lines 99-104)`() throws {
        // Parse email with display name
        let email = try EmailAddress("John Doe <john.doe@example.com>")
        #expect(email.name == "John Doe")
        #expect(email.address == "john.doe@example.com")
        #expect(email.description == "John Doe <john.doe@example.com>")
    }

    @Test
    func `Special Characters and Quoted Local Parts (README lines 109-120)`() throws {
        // Email with special characters in local part
        let specialEmail = try EmailAddress(
            localPart: "test.!#$%&'*+-/=?^_`{|}~",
            domain: "example.com"
        )
        #expect(specialEmail.localPart.contains("!#$%&'*+-/=?^_`{|}~"))

        // Quoted local part
        let quotedLocal = try EmailAddress(
            localPart: "\"john.doe\"",
            domain: "example.com"
        )
        #expect(quotedLocal.localPart == "\"john.doe\"")
        #expect(quotedLocal.domain.name == "example.com")
    }

    @Test
    func `Subdomains (README lines 124-128)`() throws {
        // Email with subdomain
        let email = try EmailAddress("test@sub1.sub2.example.com")
        #expect(email.domain.name == "sub1.sub2.example.com")
    }

    @Test
    func `RFC Format Detection (README lines 132-146)`() throws {
        let email = try EmailAddress("john.doe@example.com")

        // Check if ASCII-only
        #expect(email.isASCII == true)
        #expect(email.isInternationalized == false)

        // Access RFC-specific formats
        if let rfc5321 = email.rfc5321 {
            #expect(rfc5321.address.contains("@"))
        }
        if let rfc5322 = email.rfc5322 {
            #expect(rfc5322.address.contains("@"))
        }
    }

    @Test
    func `String Conversion (README lines 150-157)`() throws {
        // Convert from string
        let email = try EmailAddress("john.doe@example.com")
        #expect(email.address == "john.doe@example.com")

        // Convert to string
        let emailString = email.description
        let addressOnly = email.address  // Without display name
        #expect(emailString == "john.doe@example.com")
        #expect(addressOnly == "john.doe@example.com")
    }

    @Test
    func `Codable Support (README lines 162-176)`() throws {
        struct User: Codable {
            let name: String
            let email: EmailAddress
        }

        // Encoding
        let user = User(
            name: "John Doe",
            email: try EmailAddress("john.doe@example.com")
        )
        let jsonData = try JSONEncoder().encode(user)
        #expect(!jsonData.isEmpty)

        // Decoding
        let decodedUser = try JSONDecoder().decode(User.self, from: jsonData)
        #expect(decodedUser.name == "John Doe")
        #expect(decodedUser.email.address == "john.doe@example.com")
    }

    @Test
    func `RawRepresentable (README lines 180-188)`() throws {
        let email = try EmailAddress("john.doe@example.com")

        // Get raw value
        let rawValue = email.rawValue
        #expect(rawValue == "john.doe@example.com")

        // Initialize from raw value
        let reconstructed = EmailAddress(rawValue: rawValue)
        #expect(reconstructed != nil)
        #expect(reconstructed?.address == "john.doe@example.com")
    }

    @Test
    func `Email Matching (README lines 192-200)`() throws {
        let email1 = try EmailAddress("John Doe <john@example.com>")
        let email2 = try EmailAddress("john@example.com")

        // Match addresses (ignores display name)
        #expect(email1.matches(email2))
    }

    @Test
    func `Normalization (README lines 204-209)`() throws {
        let email = try EmailAddress("John Doe <john@example.com>")

        // Normalize to most restrictive format
        let normalized = email.normalized()
        #expect(normalized.address == "john@example.com")
    }

    @Test
    func `ASCII-Only Emails (README lines 213-219)`() throws {
        // Enforce ASCII-only email
        let asciiEmail = try EmailAddress(ascii: "john@example.com")
        #expect(asciiEmail.isASCII)
        #expect(asciiEmail.address == "john@example.com")
    }
}
