//
//  Response+TeaPot.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 13.06.25.
//

import Foundation

extension NetworkSpy.StubbedResponse {

    /// A stub response based on the [Hyper Text Coffee Pot Control Protocol](https://en.wikipedia.org/wiki/Hyper_Text_Coffee_Pot_Control_Protocol),
    /// returning HTTP status code 418 — *"I'm a teapot"*.
    ///
    /// This is a humorous status code originally defined in [RFC 2324](https://datatracker.ietf.org/doc/html/rfc2324),
    /// which was published as an April Fools' joke by the IETF in 1998. It indicates that the server refuses to brew coffee
    /// because it is, in fact, a teapot.
    ///
    /// Use this response as a playful default in test cases where no real stub is provided.
    ///
    /// Example:
    /// ```swift
    /// spy.responseProvider = { _ in .teaPot }
    /// ```
    public static let teaPot: Self = {
        let body = #"{"error": "I'm a teapot"}"#.data(using: .utf8)!
        return Self(
            statusCode: 418,
            headers: ["Content-Type": "application/json"],
            data: body)
    }()
}
