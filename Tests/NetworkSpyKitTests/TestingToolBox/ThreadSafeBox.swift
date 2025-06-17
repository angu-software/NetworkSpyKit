//
//  ThreadSafeBox.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 17.06.25.
//

import Foundation

final class ThreadSafeBox<Value: Sendable>: @unchecked Sendable {

    private let queue = DispatchQueue(label: "ThreadSafeBox.queue",
                                      attributes: .concurrent)
    private var _value: Value

    var value: Value {
        get {
            queue.sync {
                self._value
            }
        }
        set {
            queue.async(flags: .barrier) {
                self._value = newValue
            }
        }
    }

    init(value: Value) {
        self._value = value
    }
}
