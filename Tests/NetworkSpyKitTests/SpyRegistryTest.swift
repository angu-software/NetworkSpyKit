//
//  SpyRegistryTest.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 14.06.25.
//

import Foundation
import Testing

@testable import NetworkSpyKit

struct SpyRegistryTest {

    @Test
    func should_return_spy_for_URLRequest() async throws {
        let registry = SpyRegistry()
        let spy = NetworkSpy(sessionConfiguration: .ephemeral,
                             responseProvider: { _ in .teaPot },
                             spyRegistry: registry)
        var request = URLRequest(url: URL(string: "https://example.com")!)
        request.allHTTPHeaderFields = [NetworkSpy.headerKey: spy.id]

        #expect(registry.spy(for: request) === spy)
    }
}
