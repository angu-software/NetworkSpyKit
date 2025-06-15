import Testing

import NetworkSpyKit

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

    // TODO: throwing responseProvider
    // TODO: load data
    // TODO: change provider after initialization
}
