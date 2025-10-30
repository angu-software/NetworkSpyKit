//
//  StartLine.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 30.10.25.
//

import Foundation

extension HTTPMessageComponents {
    struct StartLine {

        private let space = " "

        // request-line
        var method: String?
        var url: URL?

        // status-line
        var statusCode: Int?
        var statusReason: String?

        var httpVersion: String?

        var isStatusLine: Bool {
            return statusCode != nil
        }

        // ✅ start-line = request-line / status-line
        func format() -> String? {
            if isStatusLine {
                return statusLine()
            }

            return requestLine()
        }

        // ✅ request-line = method SP request-target SP HTTP-version
        private func requestLine() -> String? {
            return [
                methodToken(),
                requestTarget(),
                httpVersionToken(),
            ]
                .compactMap { $0 }
                .joined(separator: space)
        }

        // request-target = origin-form / absolute-form / authority-form / asterisk-form
        // ✅ origin-form = absolute-path [ "?" query ]
        // ✅ absolute-path = <absolute-path, see [HTTP], Section 4.1>
        // ✅ query = <query, see [URI], Section 3.4>
        private func requestTarget() -> String? {
            guard let url else {
                return nil
            }

            return url.path.isEmpty ? "/" : url.path
        }

        // method = token
        private func methodToken() -> String? {

            guard let method else {
                return nil
            }

            return method.uppercased()
        }

        // status-line = HTTP-version SP status-code SP [ reason-phrase ]
        private func statusLine() -> String? {
            return [
                httpVersionToken(),
                statusCodeToken(),
                statusReasonPhrase(),
            ]
                .compactMap { $0 }
                .joined(separator: space)
        }

        // status-code = 3DIGIT
        private func statusCodeToken() -> String? {
            guard let statusCode else {
                return nil
            }

            return "\(statusCode)"
        }

        // reason-phrase = 1*( HTAB / SP / VCHAR / obs-text )
        private func statusReasonPhrase() -> String? {
            guard let statusReason else {
                return nil
            }

            return statusReason
        }

        // HTTP-version = HTTP-name "/" DIGIT "." DIGIT
        // HTTP-name = %x48.54.54.50 ; HTTP
        private func httpVersionToken() -> String? {
            guard let httpVersion else {
                return nil
            }

            return httpVersion
        }
    }
}
