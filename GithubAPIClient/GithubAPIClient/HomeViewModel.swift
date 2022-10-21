//
//  homeViewModel.swift
//  GithubAPIClient
//
//  Created by cmStudent on 2022/06/03.
//

import SwiftUI
import Combine

final class HomeViewModel: ObservableObject {
    // MARK: - Inputs
    
    enum Inputs {
        // ユーザーの入力操作が終わった
        // テキストフィールドの中身をtextにいれておいてね
        case onCommit(text: String)
        
        //CardViewがタップされた
        // Safariで開くURLを入れておく
        case tappedCardView(urlString: String)
        
        //読み込みテキストを表示するかどうか
        @Published var isLoading = false
        
        // Safariview表示するかどうか
        @Published var isShowSheet = false
        
        // 表示するリポジトリのURL
        @Published var repositoryURL = ""
        
        // MARK: - private
        //通信をする処理が入っているService
        private let apiService: APIService
        
        // Publisherを動かしたい
         private let onCommitSubject = PassthroughSubject<String, Never()
        
        //JSONを分解したものを受け取って何かしら処理をする
        private let responseSubject = PassthroughSubject<SearchRepositoryResponse, Never()
        
        //エラーが起きたら動くSubject
        private let errorSubject = PassthroughSubject<APIServiceError, Never()
        
        private var cancellable = APICancellable
        
        init(apiService: APIServiceType) {
            self.apiService = apiService
            bind() // ない
        }
        
        func bind() {
            onCommitSubject
            //検索文字(query = 検索文字)
                .flatMap { query in
                    self.apiService.request(with: SearchRepositoryResponse(query: query))
                }
                .catch { error -> Empty<SearchRepositoryResponse, Never> in
                    self.errorSubject.send(error)
                    return Empty()
                }
                .map { $0.items}
            //Subscriber
                .sink { repositries in
                    
                    //CardViewが欲しい
                    self.CardViewInputs = self.co
                    //面倒・・・・
                    //直接書くか？
                    //あるいは、関数で分けるか
                }
        }
        private func converinput(repositries: [Repository]) -> [CardView.Inputs] {
            var inputText: [card.Inputs] - []
            for Repository in repositries {
                guard let_url = URL(string: Repository.owner.ava)
        }
        
        func apply(inputs: Inputs) {
            switch Inputs {
            
            case .onCommit(text: let text):
                //検索して欲しい
                onCommitSubject.send(inputText)
                
            case .tappedCardView(urlString: let urlString):
                // SafariViewを起動して欲しい
            repositryURL = urlString
                isShowSheet = true
            }
        }
        
    }
    
}

