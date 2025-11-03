//
//  Array+SafeElementAccess.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 03.11.25.
//

import Foundation

extension Array {

    func element(at index: Int) -> Element? {
        guard indices.contains(index) else {
            return nil
        }

        return self[index]
    }
}
