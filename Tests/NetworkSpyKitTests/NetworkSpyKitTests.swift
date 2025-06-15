//
//  NetworkSpyKitTests.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 13.06.25.
//

import Foundation
import Testing

import NetworkSpyKit

// Public API tests
struct NetworkSpyKitTests {

    private typealias Response = NetworkSpy.StubbedResponse

    @Test
    func should_return_stubbed_response() async throws {
        let spy = NetworkSpy(sessionConfiguration: .default) { _ in
            return Response(statusCode: 200,
                            headers: ["Content-Type": "text/plain"],
                            data: "Hello spy!".data(using: .utf8))
        }

        let networkClient = NetworkClientFake(sessionConfiguration: spy.sessionConfiguration)

        let receivedResponse = try await networkClient.sendRequest()

        #expect(receivedResponse == Response(statusCode: 200,
                                             headers: ["Content-Type": "text/plain"],
                                             data: "Hello spy!".data(using: .utf8)))
    }

    @Test
    func should_fail_sending_request_when_response_provider_throws_error() async throws {
        let spy = NetworkSpy(sessionConfiguration: .default) { _ in
            throw TestingError.somethingWentWrong
        }

        let networkClient = NetworkClientFake(sessionConfiguration: spy.sessionConfiguration)

        do {
            _ = try await networkClient.sendRequest()
            Issue.record("Request should have failed, but did not!")
        } catch {
            let error = error as NSError
            #expect(error.domain == String(reflecting: TestingError.self))
            #expect(error.code == 0)
        }
    }

    @Test
    func should_allow_changing_response_provider_after_initalization() async throws {
        let spy = NetworkSpy(sessionConfiguration: .default) { _ in
            throw TestingError.somethingWentWrong
        }
        let networkClient = NetworkClientFake(sessionConfiguration: spy.sessionConfiguration)
        spy.responseProvider = { _ in return .teaPot }

        let response = try await networkClient.sendRequest()

        #expect(response == .teaPot)
    }

    // Default response provider
}
