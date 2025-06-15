//
//  SpyBuilder.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 14.06.25.
//

import Foundation

@testable import NetworkSpyKit

final class SpyBuilder {

    var sessionConfiguration: URLSessionConfiguration
    var responseProvider: NetworkSpy.ResponseProvider
    let spyRegistry: SpyRegistry

    init(sessionConfiguration: URLSessionConfiguration = .default,
         responseProvider: @escaping NetworkSpy.ResponseProvider = NetworkSpy.defaultResponse,
         spyRegistry: SpyRegistry) {
        self.sessionConfiguration = sessionConfiguration
        self.responseProvider = responseProvider
        self.spyRegistry = spyRegistry
    }

    func build() -> NetworkSpy {
        return NetworkSpy(sessionConfiguration: sessionConfiguration,
                          responseProvider: responseProvider,
                          spyRegistry: spyRegistry)
    }
}
