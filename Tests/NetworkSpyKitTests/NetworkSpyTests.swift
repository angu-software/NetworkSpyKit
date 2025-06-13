import Testing

@testable import NetworkSpyKit

struct NetworkSpyTests {

    private typealias Response = NetworkSpy.Response

    @Test // TODO: tags acceptanceTest
    func should_return_stubbed_response() async throws {
        await withKnownIssue("ACC: In development") {
            let spy = NetworkSpy() { _ in
                return Response(statusCode: 200,
                                headers: ["Content-Type": "text/plain"],
                                data: "Hello spy!".data(using: .utf8))
            }

            let networkClient = NetworkClient(sessionConfiguration: spy.sessionConfiguration)

            let receivedResponse = try await networkClient.sendRequest()

            #expect(receivedResponse == Response(statusCode: 200,
                                                 headers: ["Content-Type": "text/plain"],
                                                 data: "Hello spy!".data(using: .utf8)))
        }
    }
}
