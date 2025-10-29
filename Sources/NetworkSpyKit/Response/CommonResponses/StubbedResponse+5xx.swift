//
//  StubbedResponse+5xx.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 29.10.25.
//

extension NetworkSpy.StubbedResponse {

    public static var internalServerError: Self {
        return Self(statusCode: 500)
    }

    public static var notImplemented: Self {
        return Self(statusCode: 501)
    }
}
