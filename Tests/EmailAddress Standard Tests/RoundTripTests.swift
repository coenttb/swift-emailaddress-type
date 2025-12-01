//
//  RoundTripTests.swift
//  EmailAddress Tests
//
//  Tests for round-trip conversions between RFC formats
//

import Testing

@testable import EmailAddress_Standard

@Suite
struct `Round-Trip Conversion Tests` {

    @Test
    func `RFC 5321 -> EmailAddress -> RFC 5321`() throws {
        let original = try RFC_5321.EmailAddress("user@example.com")
        let emailAddress = try EmailAddress(rfc5321: original)

        guard let converted = emailAddress.rfc5321 else {
            throw EmailAddress.Error.conversionFailure
        }

        #expect(converted.address == original.address)
        #expect(converted.displayName == original.displayName)
        #expect(converted.localPart.description == original.localPart.description)
        #expect(converted.domain.name == original.domain.name)
    }

    @Test
    func `RFC 5322 -> EmailAddress -> RFC 5322`() throws {
        let original = try RFC_5322.EmailAddress("John Doe <john@example.com>")
        let emailAddress = try EmailAddress(rfc5322: original)

        guard let converted = emailAddress.rfc5322 else {
            throw EmailAddress.Error.conversionFailure
        }

        #expect(converted.address == original.address)
        #expect(converted.displayName == original.displayName)
    }

    @Test
    func `RFC 6531 -> EmailAddress -> RFC 6531`() throws {
        let original = try RFC_6531.EmailAddress("用户@example.com")
        let emailAddress = EmailAddress(rfc6531: original)
        let converted = emailAddress.rfc6531

        #expect(converted.address == original.address)
        #expect(converted.displayName == original.displayName)
    }

    @Test
    func `ASCII email has all RFC format representations`() throws {
        // Initialize from string - using init with components to avoid ambiguity
        let emailAddress = try EmailAddress(localPart: "test", domain: "example.com")

        #expect(emailAddress.isASCII == true)
        #expect(emailAddress.rfc5321 != nil)
        #expect(emailAddress.rfc5322 != nil)

        // Verify all formats produce the same address value
        let rfc5321Value = emailAddress.rfc5321?.address
        let rfc5322Value = emailAddress.rfc5322?.address
        let rfc6531Value = emailAddress.rfc6531.address

        #expect(rfc5321Value == "test@example.com")
        #expect(rfc5322Value == "test@example.com")
        #expect(rfc6531Value == "test@example.com")
    }

    @Test
    func `Internationalized email only has RFC 6531 format`() throws {
        // Create via RFC 6531 directly to avoid ambiguity
        let rfc6531 = try RFC_6531.EmailAddress("用户@example.com")
        let emailAddress = EmailAddress(rfc6531: rfc6531)

        #expect(emailAddress.isInternationalized == true)
        #expect(emailAddress.rfc5321 == nil)
        #expect(emailAddress.rfc5322 == nil)
        #expect(emailAddress.rfc6531.address == "用户@example.com")
    }
}
