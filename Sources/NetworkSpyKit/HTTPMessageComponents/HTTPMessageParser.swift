//
//  HTTPMessageParser.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 30.10.25.
//

import Foundation

struct HTTPMessageParser {

    func components(from httpMessage: String) -> HTTPMessageComponents? {
        guard let startLine = StartLineParser().startLine(from: httpMessage)
        else {
            return nil
        }

        return HTTPMessageComponents(startLine: startLine)
    }
}

private struct StartLineParser {

    private let space = " "

    func startLine(from string: String) -> HTTPMessageComponents.StartLine? {
        guard let firstLine = string.components(separatedBy: .newlines).first else {
            return nil
        }

        let components = firstLine.components(separatedBy: space)
        guard components.count >= 2 else {
            return nil
        }

        let method = components[0]
        let absolutePath = components[1]
        let httpVersion = components.count == 3 ? components[2] : nil

        return .requestLine(
            method: method,
            absolutePath: absolutePath,
            httpVersion: httpVersion
        )
    }
}
