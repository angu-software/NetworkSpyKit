//
//  NetworkSpyTest.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 13.06.25.
//

import Foundation
import Testing

@testable import NetworkSpyKit

struct NetworkSpyTest {

    @Test // FIXME: better name for test
    func should_set_spy_id_on_session_config() async throws {
        let spy = NetworkSpy(sessionConfiguration: .ephemeral) { _ in
            return .init(statusCode: 200, headers: [:])
        }

        #expect(spy.sessionConfiguration.httpAdditionalHeaders?[NetworkSpy.headerKey] as? String == spy.id)
    }

    @Test
    func should_provide_copy_of_injected_sessionConfiguration() async throws {
        let injectedConfig = URLSessionConfiguration.default
        let spy = NetworkSpy(sessionConfiguration: injectedConfig) { _ in
            return .init(statusCode: 200, headers: [:])
        }

        #expect(spy.sessionConfiguration !== injectedConfig)
    }
}
