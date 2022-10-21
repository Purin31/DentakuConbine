//
//  Repository.swift
//  GithubAPIClient
//
//  Created by cmStudent on 2022/05/31.
//

import Foundation

struct Repository: Decodable, Hashable, Identifiable {
    let id: Int
    let name: String
    let description: String?
    let stargazersCount: Int = 0
    let language: String?
    let htmlUrl: String
    let owner: Owner
}
struct Owner: Decodable, Hashable, Identifiable {
    let id: Int
    let avatarUrl: String
}
struct SearchRepositoryResponse: Decodable {
    let items: [Repository]
}

