//
//  URLRequester.swift
//  Posts
//
//

import Foundation

protocol URLRequester {
    func urlRequest(baseURL: URL, encoder: JSONEncoder) throws -> URLRequest
}

extension FetchPostsRequest: URLRequester {
    func urlRequest(baseURL: URL, encoder: JSONEncoder) throws -> URLRequest {
        let url = baseURL.appendingPathComponent("posts")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}
