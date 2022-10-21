//
//  ContentView.swift
//  EasyGesture
//
//  Created by npc on 2022/06/09.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        // タブを使う
        TabView {
            
            TapGestureView()
                .tabItem {
                    Label("タップ", systemImage: "pawprint.fill")
                }
            TapGestureWithCountView()
                .tabItem {
                    Label("タップ（カウント付き）", systemImage: "pawprint.fill")
                }
            
            LongPressGestureView()
                .tabItem {
                    Label("長押し", systemImage: "pawprint.fill")
                }
        }
    }
}

/// シンプルなTapGesture
/// タップするとカウントアップする
struct TapGestureView: View {
    @State var nyaanCount = 0
    var body: some View {
        ZStack {
            Color.yellow
                .ignoresSafeArea()
            VStack {
                Text((nyaanCount == 0 ? "" : String(nyaanCount)) + "にゃ〜ん")
                Image("cat1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    // ★★★gesture★★★
                    // シンプルなGesture
                    // gestureモディファイア＋ジェスチャーインスタンス
                    .gesture(
                        TapGesture()
                            //Gesture終了時のアクション（つまりタップし終わったら時)
                            .onEnded {_ in
                                nyaanCount += 1
                            }
                    )
            }
        }
    }
}

/// 回数でタップを判断するTapGesture
/// ダブルタップで猫が変わる
struct TapGestureWithCountView: View {
    @State var catImages = ["cat1", "cat2", "cat3"]
    @State var index = 0
    var body: some View {
        ZStack {
            Color.red
                .ignoresSafeArea()
            VStack {
                Text("ダブルタップねこChan")
                Image(catImages[index])
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    // ★★★gesture★★★
                    // ダブルタップで動作する
                    .gesture(
                        TapGesture(count: 2)
                            //Gesture終了時のアクション（つまりタップし終わったら時)
                            .onEnded{_ in
                                index += 1
                                index %= 3
                            }
                    )
            }
            
            
        }
    }
    
}


/// 長押し＋ドラッグ
/// 猫が移動する
struct LongPressGestureView: View {
    
    
    
    // ジェスチャー用のプロパティラッパー
    // GestureStateを付けるとgetのみしかできなくなる
    // setはGestureによって行われる
    
    
    
    
    @GestureState private var isLongPressed = false
    
    @State private var offset: CGSize = .zero
    
    var body: some View {
        // ★★★★★
        // GestureStateによる影響でBody内に処理をGestureの処理を書く
        // 他の方法もないわけではない
        // ★★★★★
        
        // ★Gestureのインスタンスを変数化できる
        
        // DragGestureはドラッグ用のジェスチャー
        let drag = DragGesture()
            // 値に変化があった時の処理
            // valueはドラッグジェスチャーが持っている様々な値の入れ物
            .onChanged{ value in
                // .translationは移動量
                self.offset = value.translation
            }
            .onEnded{_ in
                self.offset = .zero
            }
        
        // LongPressGestureは長押し用のジェスチャー
        // Double.greatestFiniteMagnitude→超大きい数字（無限大よりは小さいらしい）
        // minimumDuration→ジェスチャーが成功するまでの最短の時間
        // maximumDistance→ジェスチャーが成功するまでの最長の時間
        // つまり、このジェスチャーは終わらない（endedしない）
        let longPress = LongPressGesture(minimumDuration:
                                            .greatestFiniteMagnitude, maximumDistance: .greatestFiniteMagnitude)
            // updating→ジェスチャーの値が変わっている間の処理
            .updating($isLongPressed) { value, state, _ in
                state = value
            }
            .onEnded{ _ in
                // .greatestFiniteMagnitubeにしているからここは到達しない
                print("終わり")
            }
        
        ZStack {
            Color.gray
                .ignoresSafeArea()
            VStack {
                Text(isLongPressed ? "にゃあああああああ" : "にゃ")
                Image("cat1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    // 猫の位置
                    .offset(self.offset)
                    // アニメーション（バネのような動きをするアニメーション）
                    .animation(.spring(), value: offset)
                    // ★★★gesture★★★
                    // ダブルタップで動作する
                    .gesture(
                        longPress
                    )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
