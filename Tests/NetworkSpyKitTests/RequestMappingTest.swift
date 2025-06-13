//
//  RequestMappingTest.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 13.06.25.
//

import Foundation

import Testing

@testable import NetworkSpyKit

struct RequestMappingTest {

    @Test
    func should_map_url_of_URLRequest() async throws {
        let urlRequest = URLRequest(url: URL(string: "https://example.com?foo=bar&baz=qux")!)

        let request = try #require(Request(urlRequest: urlRequest))

        #expect(request.url.absoluteString == "https://example.com?foo=bar&baz=qux")
    }

    @Test
    func should_map_httpMethod_of_URLRequest() async throws {
        var urlRequest = URLRequest(url: URL(string: "https://example.com?foo=bar&baz=qux")!)
        urlRequest.httpMethod = "POST"

        let request = try #require(Request(urlRequest: urlRequest))

        #expect(request.httpMethod == "POST")
    }

    @Test
    func should_map_headers_of_URLRequest() async throws {
        var urlRequest = URLRequest(url: URL(string: "https://example.com?foo=bar&baz=qux")!)
        urlRequest.allHTTPHeaderFields = ["Content-Type": "application/json"]

        let request = try #require(Request(urlRequest: urlRequest))

        #expect(request.headers == ["Content-Type": "application/json"])
    }

    @Test
    func should_map_httpBody_of_URLRequest() async throws {
        let bodyData = "Hello".data(using: .utf8)!
        var urlRequest = URLRequest(url: URL(string: "https://example.com?foo=bar&baz=qux")!)
        urlRequest.httpBody = bodyData

        let request = try #require(Request(urlRequest: urlRequest))

        #expect(request.bodyData == bodyData)
    }

    @Test
    func should_map_httpBodyStream_of_URLRequest() async throws {
        let bodyData = "Hello".data(using: .utf8)!
        var urlRequest = URLRequest(url: URL(string: "https://example.com?foo=bar&baz=qux")!)
        urlRequest.httpBodyStream = InputStream(data: bodyData)

        let request = try #require(Request(urlRequest: urlRequest))

        #expect(request.bodyData == bodyData)
    }
}
