//
//  MotionManager.swift
//  MotionManager
//
//  Created by cmStudent on 2022/07/22.
//

import Foundation
import CoreMotion

final class MotionManager {
    // staticでインスタンスを保持しておく
    // MotionManager.sharedでアクセスができる
    static let shared: MotionManager = .init()
    //privateのletでCMMMotionManagerインスタンスを作成する
    private let motion = CMMotionManager()
    
    private let queue = OperationQueue()
    
    //シングルトンにするためにinitを潰す
    private init() { }
    
    func startQueuedUpdate() {
        // 加速度センサーが使えない場合はこの先の処理をしない
        guard motion.isGyroAvailable else { return }
     //更新間隔
    motion.accelerometerUpdateInterval = 6.0 / 60.0 // 0.1秒間隔
    
    // 加速度センサーを利用して値を取得する
    //取ってくるdataの型はCMAcceremoterData?になっている
    motion.startGyroUpdates(to: queue) { data, error in
        //dataはオプショナル型なので、安全に取り出す
        if let validData = data {
            let x = validData.rotationRate.x
            let y = validData.rotationRate.y
            let z = validData.rotationRate.z
            
            print("x: \(x)")
            print("y: \(y)")
            print("z: \(z)")
        }
      }
   }
}

