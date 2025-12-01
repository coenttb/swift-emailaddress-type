//
//  File.swift
//  swift-emailaddress-standard
//
//  Created by Coen ten Thije Boonkkamp on 19/11/2025.
//

import RFC_6531

extension String {
    public init(
        _ emailAddress: EmailAddress_Standard.EmailAddress
    ) {
        self =
            emailAddress.rfc5321
            .map(\.description) ?? emailAddress.rfc5322
            .map { String($0) } ?? String(emailAddress.rfc6531)
    }
}
