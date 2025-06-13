//
//  SypRegistry.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 13.06.25.
//

import Foundation

final class SpyRegistry: @unchecked Sendable {

    static let shared = SpyRegistry()

    private let queue = DispatchQueue(label: "com.angu-software.NetworkSpyKit.SpyRegistry",
                                      attributes: .concurrent)
    private var registry: [String: NetworkSpy] = [:]

    func register(_ spy: NetworkSpy) {
        queue.async(flags: .barrier) {
            self.registry[spy.id] = spy
        }
    }

    func spy(byId id: String) -> NetworkSpy? {
        return queue.sync {
            return registry[id]
        }
    }
}
