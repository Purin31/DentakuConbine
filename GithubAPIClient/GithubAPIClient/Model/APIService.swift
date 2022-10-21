//
//  File.swift
//  GithubAPIClient
//
//  Created by cmStudent on 2022/05/31.
//

import Foundation

protocol APIServiceType {
    func request<Request>(with request: Request) ->
    AnyPublisher<Request.Response, APIServiceError>
    where Request: APIRequestType
}

///API通信をしてDecordeまでする
final class APIService: APIServiceType {
    
    private let baseURLString: String
    
    init(baseURLString: String = "https://api.github.com") {
        self.baseURLString = baseURLString
    }
    
    func request<Request>(with request: Request) ->
    AnyPublisher<Request.Response, APIServiceError>
    where Request: APIRequestType {
        guard let pathURL = URL(string: request.path,
                                relativeTo: URL(string: baseURLString)) else {
            return Fail(error: APIServiceError.invalidURL).eraseToAnyPublisher()
        }
        var urlComponents = URLComponents(url: pathURL, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = request.queryItems
        var request = URLRequest(url: urlComponents.url!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let decorder = JSONDecoder()
        decorder.keyDecodingStrategy = .convertFromSnakeCase
        // URLSessionのPublisherを実行
        return URLSession.shared.dataTaskPublisher(for: request)
        // mapでレスポンスデータのストリームに変換
            .map { data, urlResponse in data }
        // エラーが起きたらresponseErrorを返す
            .mapError { _ in APIServiceError.responseError }
        // JSONからデータオブジェクトにデコードする
            .decode(type: Request.Response.self, decoder: decorder)
        // デコードでエラーが起きたらparseErrorを返す
            .mapError(APIServiceError.parseError)
        // ストリームをメインスレッドに流れるように変換
            .receive(on: RunLoop.main)
        
        // Publisherの型を消去する
            .eraseToAnyPublisher()
    }
}
