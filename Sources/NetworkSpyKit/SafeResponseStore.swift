//
//  SafeResponseStore.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 15.06.25.
//

import Foundation

final class SafeResponseStore: @unchecked Sendable {

    typealias ResponseProvider = NetworkSpy.ResponseProvider

    var responseProvider: ResponseProvider {
        get {
            queue.sync {
                return self._responseProvider
            }
        }
        set {
            queue.async(flags: .barrier) {
                self._responseProvider = newValue
            }
        }
    }

    private let queue: DispatchQueue = DispatchQueue(label: "com.angu-software.SafeResponseStore.queue",
                                                     attributes: .concurrent)

    private var _responseProvider: ResponseProvider

    init(responseProvider: @escaping ResponseProvider) {
        self._responseProvider = responseProvider
    }
}
