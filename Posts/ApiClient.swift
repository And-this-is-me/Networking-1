//
//  ApiClient.swift
//  Posts
//
//

import SwiftUI

// Error definition
enum ApiClientError: Error {
    case mappingError
    case httpFailed(Int)
}

// Actor declaration
actor ApiClient {

    // Initialization
    init(
        requestPosts: @Sendable @escaping (FetchPostsRequest) async throws -> [Post]
    ) {
        self.requestPosts = requestPosts
    }
    
    public var requestPosts: (FetchPostsRequest) async throws -> [Post]
    
    // Generic method to parse requests
    static func handle <Success: Decodable>(
        baseURL: URL,
        urlSession: URLSession,
        decoder: JSONDecoder,
        encoder: JSONEncoder,
        requestID: UUID,
        requester: URLRequester
    ) async throws -> Success {
        
        let request = try requester.urlRequest(
            baseURL: baseURL,
            encoder: encoder
        )
        
        let element: (data: Data, urlResponse: URLResponse) = try await urlSession.data(for: request)
        
        if let response = element.urlResponse as? HTTPURLResponse, response.statusCode != 200 {
            throw ApiClientError.httpFailed(response.statusCode)
        }
        
        do {
            let response = try decoder.decode(Success.self, from: element.data)
            return response
        } catch {
            throw ApiClientError.mappingError
        }
    }
    
    static func live(
        urlSession: URLSession = .shared,
        jsonDecoder: JSONDecoder = .init(),
        jsonEncoder: JSONEncoder = .init(),
        buildUUID: @escaping () -> UUID = { UUID() }
    ) -> Self {
        jsonDecoder.dateDecodingStrategy = .iso8601
        
        return .init(
            requestPosts: {
                try await handle(
                    baseURL: URL(string: "https://jsonplaceholder.typicode.com")!,
                    urlSession: urlSession,
                    decoder: jsonDecoder,
                    encoder: jsonEncoder,
                    requestID: buildUUID(),
                    requester: $0
                )
            }
        )
    }
}
