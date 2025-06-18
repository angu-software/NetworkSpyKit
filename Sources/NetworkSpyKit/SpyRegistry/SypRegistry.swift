//
//  SypRegistry.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 13.06.25.
//

import Foundation

final class SpyRegistry: @unchecked Sendable {

    private struct WeakSpy {
        weak var spy: NetworkSpy?

        init(_ spy: NetworkSpy?) {
            self.spy = spy
        }
    }

    static let shared = SpyRegistry()

    private let queue = DispatchQueue(label: "com.angu-software.NetworkSpyKit.SpyRegistry")
    private var registry: [String: WeakSpy] = [:]

    func register(_ spy: NetworkSpy) {
        queue.async(flags: .barrier) {
            self.registry[spy.id] = WeakSpy(spy)
        }
    }

    func unregister(byId spyId: String) {
        queue.async(flags: .barrier) {
            self.registry[spyId] = nil
        }
    }

    func spy(byId id: String) -> NetworkSpy? {
        return queue.sync {
            return registry[id]?.spy
        }
    }
}


