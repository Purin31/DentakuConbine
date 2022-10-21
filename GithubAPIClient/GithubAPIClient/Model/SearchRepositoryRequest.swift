//
//  SearchRepositoryRequest.swift
//  GithubAPIClient
//
//  Created by cmStudent on 2022/05/31.
//

import Foundation

protocol APIRequestType {
    associatedtype Response: Decodable
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
}

struct SearchRepositoryRequest: APIRequestType {
    typealias Response = SearchRepositoryResponse
    var path: String { return "/search/repositories" }
    var queryItems: [URLQueryItem]? {
        return [
            .init(name: "q", value: query),
            .init(name: "order", value: "desc")
        ]
    }
    private let query: String
    init(query: String) {
        self.query = query
    }
}
