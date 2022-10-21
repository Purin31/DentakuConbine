//
//  Homeview.swift
//  GithubAPIClient
//
//  Created by cmStudent on 2022/06/03.
//

import SwiftUI

struct HomeView: View {
    @stateObject private var viewModel = HomeviewModel(apiService: APIService())
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
