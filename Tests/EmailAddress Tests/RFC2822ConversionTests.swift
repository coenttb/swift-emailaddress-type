import Testing
import Foundation
@testable import EmailAddress
import RFC_2822

@Suite("RFC 2822 AddrSpec Conversion Tests")
struct RFC2822ConversionTests {

    @Test("Convert EmailAddress to RFC_2822.AddrSpec")
    func emailAddressToAddrSpec() throws {
        let email = try EmailAddress("user@example.com")
        let addrSpec = try RFC_2822.AddrSpec(email)

        #expect(addrSpec.localPart == "user")
        #expect(addrSpec.domain == "example.com")
        #expect(addrSpec.description == "user@example.com")
    }

    @Test("Convert RFC_2822.AddrSpec to EmailAddress")
    func addrSpecToEmailAddress() throws {
        let addrSpec = try RFC_2822.AddrSpec(localPart: "test", domain: "example.org")
        let email = try EmailAddress(addrSpec)

        #expect(email.rfc5322?.localPart.stringValue == "test")
        #expect(email.rfc5322?.domain.name == "example.org")
    }

    @Test("Round-trip conversion EmailAddress -> AddrSpec -> EmailAddress")
    func roundTripConversion() throws {
        let original = try EmailAddress("hello@world.com")
        let addrSpec = try RFC_2822.AddrSpec(original)
        let converted = try EmailAddress(addrSpec)

        #expect(original == converted)
    }

    @Test("Convert EmailAddress with subdomain to RFC_2822.AddrSpec")
    func emailWithSubdomainToAddrSpec() throws {
        let email = try EmailAddress("admin@mail.example.com")
        let addrSpec = try RFC_2822.AddrSpec(email)

        #expect(addrSpec.localPart == "admin")
        #expect(addrSpec.domain == "mail.example.com")
    }

    @Test("Convert EmailAddress with special characters to RFC_2822.AddrSpec")
    func emailWithSpecialCharsToAddrSpec() throws {
        let email = try EmailAddress("user+tag@example.com")
        let addrSpec = try RFC_2822.AddrSpec(email)

        #expect(addrSpec.localPart == "user+tag")
        #expect(addrSpec.domain == "example.com")
    }
}
