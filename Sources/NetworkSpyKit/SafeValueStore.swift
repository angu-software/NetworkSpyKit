//
//  SafeValueStore.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 15.06.25.
//

import Foundation

final class SafeValueStore<Value: Sendable>: @unchecked Sendable {

    var value: Value {
        get {
            queue.sync {
                return self._value
            }
        }
        set {
            queue.async(flags: .barrier) {
                self._value = newValue
            }
        }
    }

    private let queue: DispatchQueue = DispatchQueue(label: "com.angu-software.SafeValueStore.queue",
                                                     attributes: .concurrent)

    private var _value: Value

    init(value: Value) {
        self._value = value
    }
}
