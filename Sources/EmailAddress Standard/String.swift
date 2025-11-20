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
        self = emailAddress.rfc5321.map(String.init) ?? emailAddress.rfc5322.map(String.init) ?? String(emailAddress.rfc6531)
    }
}
