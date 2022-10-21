//
//  ContentView.swift
//  MotionManager
//
//  Created by cmStudent on 2022/07/22.
//

import SwiftUI

struct ContentView: View {
    //MotionManagerのインスタンスを利用する
    let motionManager = MotionManager.shared
    
    var body: some View {
        Button {
            motionManager.startQueuedUpdate()
        } label: {
            Text("motionManager")
                .font(.title)

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
