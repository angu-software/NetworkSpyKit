//
//  StubbedResponse+4xx.swift
//  NetworkSpyKit
//
//  Created by Andreas Günther on 29.10.25.
//

extension NetworkSpy.StubbedResponse {

    public static var notFound: Self {
        return Self(statusCode: 400)
    }
}
