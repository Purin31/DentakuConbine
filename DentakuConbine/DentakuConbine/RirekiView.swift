//
//  RirekiView.swift
//  DentakuConbine
//
//  Created by cmStudent on 2022/10/21.
//

import SwiftUI

struct RirekiView: View {
    @ObservedObject var model: DentakuModel = .DM
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            Color.gray
            VStack {
                Spacer().frame(height: 20)
                ScrollView {
                    ForEach(model.rireki, id: \.self){ rireki in
                        Text(rireki)
                            .foregroundColor(Color.black)
                            .frame(width: UIScreen.main.bounds.width-40, height: 50)
                            .background(Color.white)
                    }
                }
                Button(action: {
                    dismiss()
                }, label: {
                    Text("画面を閉じる")
                        .foregroundColor(Color.white)
                        .padding()
                        .background(Color.black)
                })
                Spacer().frame(height: 20)
            }
        }
    }
}

struct RirekiView_Previews: PreviewProvider {
    static var previews: some View {
        RirekiView()
    }
}

