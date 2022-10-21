//
//  ContentView.swift
//  DentakuConbine
//
//  Created by cmStudent on 2022/10/21.
//

import SwiftUI

struct ContentView: View {
    @State var isPrsented = false
    var body: some View {
        ZStack {
            Color.black
            VStack {
               Text("林計算機")
                    .foregroundColor(Color.white)
                    .font(.custom("Hiragino Mincho Pro", size: 80))
                    .padding(.bottom, 100)
                
                Button(action: {
                    isPrsented.toggle()
                }, label: {
                    Text("計算する")
                        .font(.title)
                        .foregroundColor(Color.white)
                        .padding()
                        .border(Color.white)
                        .padding(5)
                        .border(Color.white)
                })
            }.fullScreenCover(isPresented: $isPrsented, content: {
                DentakuView()
            })
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

