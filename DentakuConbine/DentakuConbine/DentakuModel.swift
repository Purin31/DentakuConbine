//
//  DentakuModel.swift
//  DentakuConbine
//
//  Created by cmStudent on 2022/10/21.
//

import SwiftUI
import Combine

class DentakuModel: ObservableObject {
    
    @Published var collect = ""
    @Published var display = "0"
    @Published var kigou = ""
    @Published var rireki: [String] = [""]
    let rirekiDefault = "まだ何も計算してませんよ。"
    
    @Published var isPrsented = false
    
    static let DM = DentakuModel()
    
    init() {
        rireki = ["まだ何も計算してませんよ。"]
    }

    func pushedButton(message: String) {
        switch message {
        case "/": kigou = message; collect = display; display = "0";
        case "X": kigou = message; collect = display; display = "0";
        case "ー": kigou = message; collect = display; display = "0";
        case "＋": kigou = message; collect = display; display = "0";
        case "=": keisan()
        case "AC": reset()
        case "履歴": isPrsented.toggle()
        default: if display == "0" {display = message} else { display += message}
        }
    }
    
    func keisan() {
        if collect == "" { return }
        
        let num1 = Int(self.collect)!
        let num2 = Int(self.display)!
        var result = 0
        switch kigou {
        case "/": result = num1/num2
        case "X": result = num1*num2
        case "ー": result = num1-num2
        case "＋": result = num1+num2
        default: return
        }
        
        collect = "\(num1) \(kigou) \(num2) = "
        display = "\(result)"
        kigou = ""
        if rireki[0] == rirekiDefault {
            rireki[0] = "\(collect) \(result)"
        } else {
            rireki.append("\(collect) \(result)")
        }
    }
    
    func reset() {
        collect = ""
        display = "0"
        kigou = ""
    }
    
}


let subject = PassthroughSubject<String, Never>()

final class Receiver {
    private var subscriptions = Set<AnyCancellable>()
    private let object = SomeObject()
    init() {
        subject
//            .sink { value in
//                print("Received value: ", value)
//            }
            .assign(to: \.hoge, on: object)
            .store(in: &subscriptions)
    }
}

final class SomeObject {
    let model: DentakuModel = .DM
    var hoge: String = "" {
        didSet {
            model.pushedButton(message: hoge)
        }
    }
}
