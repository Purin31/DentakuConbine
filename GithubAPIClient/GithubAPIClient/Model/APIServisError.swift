//
//  APIServis.swift
//  GithubAPIClient
//
//  Created by cmStudent on 2022/05/31.
//

enum APIServiceError: Error {
    case invalidURL
    case responseError
    case parseError(Error)
}
