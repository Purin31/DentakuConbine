//
//  DentakuView.swift
//  DentakuConbine
//
//  Created by cmStudent on 2022/10/21.
//

import SwiftUI

struct DentakuView: View {
    @ObservedObject var model: DentakuModel = .DM
    let buttonArray = ["7","8","9","/","4","5","6","X",
                       "1","2","3","ー","0","00","=","＋"]
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Text("\(model.collect) \(model.kigou)")
                    .font(.custom("Hiragino", size: 20))
                    .frame(width: UIScreen.main.bounds.width-40, alignment: .trailing)
                    .padding(.trailing, 20)
                    .padding(.bottom, 10)
                Text("\(model.display)")
                    .font(.custom("Hiragino", size: 50))
                    .frame(width: UIScreen.main.bounds.width-40, alignment: .trailing)
                    .padding(.trailing, 20)
                    .padding(.bottom, 50)
                ForEach(0..<4){ i in
                    HStack {
                        ForEach(0..<4){ n in
                            ButtonView(icon: buttonArray[i*4 + n])
                        }
                    }
                }
                HStack {
                    ButtonView(icon: "AC")
                    ButtonView(icon: "履歴")
                        .fullScreenCover(isPresented: $model.isPrsented, content: {
                            RirekiView()
                        })
                }
                Spacer().frame(height: 50)
            }
        }
        
    }
}

struct DentakuView_Previews: PreviewProvider {
    static var previews: some View {
        DentakuView()
    }
}

struct ButtonView: View {
    let model: DentakuModel = .DM
    let icon: String
    var body: some View {
        Button(action: {
            model.pushedButton(message: icon)
            print(icon)
        }, label: {
            Circle()
                .frame(width: 80, height: 80)
                .foregroundColor(Color.gray)
                .overlay(
                    Text(icon)
                        .font(.custom("Hiragino", size: 30))
                        .foregroundColor(Color.white)
                )
        })
    }
}
