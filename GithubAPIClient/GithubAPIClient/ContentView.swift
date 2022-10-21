//
//  ContentView.swift
//  GithubAPIClient
//
//  Created by cmStudent on 2022/06/03.
//

import SwiftUI

struct ContentView: View {
    init() {
        if #available(iOS 15.0, *) {
            UINavigationBar.appearance()
                .scrollEdgeAppearance =
                UINavigationBarAppearance()
        }
    }
    

    var body: some View {
        // SearchView()
        SafariView(url: URL(string: "https://www.jec.ac.jp")!)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
