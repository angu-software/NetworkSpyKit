//
//  RequestRecorder.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 17.06.25.
//

import Foundation

final class RequestRecorder: @unchecked Sendable {

    private let queue = DispatchQueue(label: "com.angu-software.NetworkSpyKit.RequestRecorder")
    private var requests: [Request] = []

    var recordedRequests: [Request] {
        queue.sync {
            self.requests
        }
    }

    func record(_ request: Request) {
        queue.async(flags: .barrier) {
            self.requests.append(request)
        }
    }
}
