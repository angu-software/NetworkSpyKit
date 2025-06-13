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

final class NetworkClient {

    private let session: URLSession

    init(sessionConfiguration: URLSessionConfiguration) {
        self.session = URLSession(configuration: sessionConfiguration)
    }

    func sendRequest() async throws -> NetworkSpy.Response {
        var request = URLRequest(url: URL(string: "https://example.com")!)
        request.httpMethod = "GET"

        let (data, urlResponse) =  try await session.data(for: request)

        let httpURLResponse = urlResponse as! HTTPURLResponse

        return NetworkSpy.Response(statusCode: httpURLResponse.statusCode,
                                   headers: httpURLResponse.allHeaderFields as! [String: String],
                                   data: data)
    }
}

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

extension NetworkSpy {

    struct Response: Equatable {
        var statusCode: Int
        var headers: [String: String]
        var data: Data?
    }
}
