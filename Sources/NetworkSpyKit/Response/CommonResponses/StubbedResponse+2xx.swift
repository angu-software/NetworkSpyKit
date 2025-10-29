//
//  StubbedResponse+Success.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 29.10.25.
//

extension NetworkSpy.StubbedResponse {

    public static var ok: Self {
        return Self(statusCode: 200)
    }
}
