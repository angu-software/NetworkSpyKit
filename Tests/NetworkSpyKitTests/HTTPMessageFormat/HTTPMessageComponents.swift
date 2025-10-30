//
//  HTTPMessageComponents.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 30.10.25.
//

import Foundation

struct HTTPMessageComponents {

    // https://www.rfc-editor.org/rfc/rfc9112.pdf
    // HTTP-message = HTTP-message = start-line CRLF *( field-line CRLF ) CRLF [ message-body ]

    // start-line = request-line / status-line
    // request-line = method SP request-target SP HTTP-version
    // method = token
    // request-target = origin-form / absolute-form / authority-form / asterisk-form
    // HTTP-version = HTTP-name "/" DIGIT "." DIGIT
    // HTTP-name = %x48.54.54.50 ; HTTP

    // field-line = field-name ":" OWS field-value OWS
    // field-name = <field-name, see [HTTP], Section 5.1>
    // field-value = <field-value, see [HTTP], Section 5.5>

    // message-body = *OCTET

    // origin-form = absolute-path [ "?" query ]
    // absolute-path = <absolute-path, see [HTTP], Section 4.1>
    // query = <query, see [URI], Section 3.4>

    var url: URL?

    func httpMessageFormat() -> String {
        guard let url else {
            return ""
        }

        return url.path
    }
}

import Testing

struct HTTPMessageComponentsTests {

    private let url = URL(string: "https://www.rfc-editor.org/rfc/rfc9112.pdf")

    @Test
    func givenNothing_itBuildsEmptyString() {
        let components = HTTPMessageComponents()

        #expect(components.httpMessageFormat().isEmpty)
    }

    @Test
    func givenURL_itContainsAbsolutePath() {
        var components = HTTPMessageComponents()
        components.url = url

        #expect(components.httpMessageFormat() == "/rfc/rfc9112.pdf")
    }
}
