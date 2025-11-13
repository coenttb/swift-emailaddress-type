//
//  RoundTripTests.swift
//  EmailAddress Tests
//
//  Tests for round-trip conversions between RFC formats
//

import Foundation
@testable import EmailAddress
import RFC_5321
import RFC_5322
import RFC_6531
import Testing

@Suite("Round-Trip Conversion Tests")
struct RoundTripTests {

    @Test("RFC 5321 -> EmailAddress -> RFC 5321")
    func rfc5321RoundTrip() throws {
        let original = try RFC_5321.EmailAddress("user@example.com")
        let emailAddress = try EmailAddress(rfc5321: original)

        guard let converted = emailAddress.rfc5321 else {
            throw EmailAddress.Error.conversionFailure
        }

        #expect(converted.addressValue == original.addressValue)
        #expect(converted.displayName == original.displayName)
        #expect(converted.localPart.description == original.localPart.description)
        #expect(converted.domain.name == original.domain.name)
    }

    @Test("RFC 5322 -> EmailAddress -> RFC 5322")
    func rfc5322RoundTrip() throws {
        let original = try RFC_5322.EmailAddress("John Doe <john@example.com>")
        let emailAddress = try EmailAddress(rfc5322: original)

        guard let converted = emailAddress.rfc5322 else {
            throw EmailAddress.Error.conversionFailure
        }

        #expect(converted.addressValue == original.addressValue)
        #expect(converted.displayName == original.displayName)
    }

    @Test("RFC 6531 -> EmailAddress -> RFC 6531")
    func rfc6531RoundTrip() throws {
        let original = try RFC_6531.EmailAddress("用户@example.com")
        let emailAddress = EmailAddress(rfc6531: original)
        let converted = emailAddress.rfc6531

        #expect(converted.addressValue == original.addressValue)
        #expect(converted.displayName == original.displayName)
    }

    @Test("ASCII email has all RFC format representations")
    func asciiEmailAllFormats() throws {
        // Initialize from string - using init with components to avoid ambiguity
        let emailAddress = try EmailAddress(localPart: "test", domain: "example.com")

        #expect(emailAddress.isASCII == true)
        #expect(emailAddress.rfc5321 != nil)
        #expect(emailAddress.rfc5322 != nil)

        // Verify all formats produce the same address value
        let rfc5321Value = emailAddress.rfc5321?.addressValue
        let rfc5322Value = emailAddress.rfc5322?.addressValue
        let rfc6531Value = emailAddress.rfc6531.addressValue

        #expect(rfc5321Value == "test@example.com")
        #expect(rfc5322Value == "test@example.com")
        #expect(rfc6531Value == "test@example.com")
    }

    @Test("Internationalized email only has RFC 6531 format")
    func internationalizedEmailFormat() throws {
        // Create via RFC 6531 directly to avoid ambiguity
        let rfc6531 = try RFC_6531.EmailAddress("用户@example.com")
        let emailAddress = EmailAddress(rfc6531: rfc6531)

        #expect(emailAddress.isInternationalized == true)
        #expect(emailAddress.rfc5321 == nil)
        #expect(emailAddress.rfc5322 == nil)
        #expect(emailAddress.rfc6531.addressValue == "用户@example.com")
    }
}
