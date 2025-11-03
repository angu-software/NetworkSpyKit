//
//  String+Lines.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 03.11.25.
//


extension String {

    var lines: [String] {
        return components(separatedBy: .newlines)
    }
}