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

    private let spyRegistry: SpyRegistry
    private let spyBuilder: SpyBuilder

    init() {
        self.spyRegistry = SpyRegistry()
        self.spyBuilder = SpyBuilder(spyRegistry: spyRegistry)
    }

    @Test
    func should_return_spy_for_URLRequest() async throws {
        let spy = spyBuilder.build()
        let request: URLRequest = .fixture(spyId: spy.id)

        #expect(spyRegistry.spy(for: request) === spy)
    }
}
