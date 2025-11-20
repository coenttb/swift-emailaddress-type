import Testing
@testable import EmailAddress_Standard

@Suite
struct `RFC 2822 AddrSpec Conversion Tests` {

    @Test
    func `Convert EmailAddress to RFC_2822.AddrSpec`() throws {
        let email = try EmailAddress("user@example.com")
        let addrSpec = try RFC_2822.AddrSpec(email)

        #expect(addrSpec.localPart == "user")
        #expect(addrSpec.domain == "example.com")
        #expect(addrSpec.description == "user@example.com")
    }

    @Test
    func `Convert RFC_2822.AddrSpec to EmailAddress`() throws {
        let addrSpec = try RFC_2822.AddrSpec(localPart: "test", domain: "example.org")
        let email = try EmailAddress(addrSpec)

        #expect(email.rfc5322?.localPart.description == "test")
        #expect(email.rfc5322?.domain.name == "example.org")
    }

    @Test
    func `Round-trip conversion EmailAddress -> AddrSpec -> EmailAddress`() throws {
        let original = try EmailAddress("hello@world.com")
        let addrSpec = try RFC_2822.AddrSpec(original)
        let converted = try EmailAddress(addrSpec)

        #expect(original == converted)
    }

    @Test
    func `Convert EmailAddress with subdomain to RFC_2822.AddrSpec`() throws {
        let email = try EmailAddress("admin@mail.example.com")
        let addrSpec = try RFC_2822.AddrSpec(email)

        #expect(addrSpec.localPart == "admin")
        #expect(addrSpec.domain == "mail.example.com")
    }

    @Test
    func `Convert EmailAddress with special characters to RFC_2822.AddrSpec`() throws {
        let email = try EmailAddress("user+tag@example.com")
        let addrSpec = try RFC_2822.AddrSpec(email)

        #expect(addrSpec.localPart == "user+tag")
        #expect(addrSpec.domain == "example.com")
    }
}
