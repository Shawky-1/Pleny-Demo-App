//
//  APIError.swift
//  Pleny_Demo_App
//
//  Created by Ahmed Shawky on 07/03/2023.
//

import Foundation

/// Error types that can occur during API requests
enum APIError: Error {
    case badRequest
    case unauthorized(String)
    case accessDenied
    case resourceNotFound
    case unknown(Int)
    case statusCode(Int, data: Data)

    /// Initialize error based on HTTP status code and optional data
    init(statusCode: Int, data: Data?) {
        switch statusCode {
        case 200...299:
            self = .unknown(statusCode)
        case 400:
            if let data = data {
                let decoder = JSONDecoder()
                if let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) {
                    self = .unauthorized(errorMessage.message)
                } else {
                    self = .unknown(statusCode)
                }
            } else {
                self = .unknown(statusCode)
            }
        case 403:
            self = .accessDenied
        case 404:
            self = .resourceNotFound
        default:
            self = .unknown(statusCode)
        }
    }
}

/// Struct to hold error message returned from server
struct ErrorMessage: Decodable {
    let message: String
}
