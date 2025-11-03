//
//  MessageStringParts.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 03.11.25.
//

import Foundation

struct MessageStringParts {

    let message: String
    let body: String?

    var startLine: String {
        var messageLines = messageLines
        return messageLines.removeFirst()
    }

    var fieldLines: [String] {
        var messageLines = messageLines
        _ = messageLines.removeFirst()
        return messageLines
    }

    private static let emptyLine = "\n\n"

    private var messageLines: [String] {
        return message.lines
    }

    init?(string: String) {
        let scanner = Scanner(string: string)
        scanner.charactersToBeSkipped = nil
        guard let messagePart = scanner.scanUpToString(MessageStringParts.emptyLine) else {
            return nil
        }

        _ = scanner.scanString(MessageStringParts.emptyLine)
        let bodyPart = scanner.string[scanner.currentIndex...]

        self.init(message: messagePart,
                  body: bodyPart.isEmpty ? nil : String(bodyPart))
    }

    private init(message: String,
                 body: String?) {
        self.message = message
        self.body = body
    }
}
