//
//  SpyRegistry+URLRequest.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 14.06.25.
//

import Foundation

extension SpyRegistry {

    func spy(for request: URLRequest) -> NetworkSpy? {
        guard let sypId = spyId(for: request) else {
            return nil
        }

        return spy(byId: sypId)
    }

    private func spyId(for request: URLRequest) -> String? {
        return request.allHTTPHeaderFields?[NetworkSpy.headerKey]
    }
}
