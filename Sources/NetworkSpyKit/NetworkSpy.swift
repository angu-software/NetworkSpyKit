//
//  NetworkSpy.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 13.06.25.
//

import Foundation

final class NetworkSpy {

    typealias Request = URLRequest

    typealias ResponseProvder = (Request) -> Response

    let sessionConfiguration: URLSessionConfiguration
    var responseProvder: ResponseProvder

    init(sessionConfiguration: URLSessionConfiguration = .default,
         responseProvder: @escaping ResponseProvder) {
        self.sessionConfiguration = sessionConfiguration
        self.responseProvder = responseProvder
    }
}
