//
//  ViewModel.swift
//  SilentCamera
//
//  Created by cmStudent on 2022/06/24.
//

import Foundation
import Photos

// 継承はclassの記述のあるほうに書く。じゃないとエラーになる
class ViewModel: NSObject {
    // 入力と出力を管理する機能
    // 入力装置はどれで、出力はどれで〜〜〜みたいなことをやってくれる
    let captureSession = AVCaptureSession()
    
    // デバイス。背面カメラ（無いかもしれない）
    var mainCamera: AVCaptureDevice?
    // インナーカメラ（無いかもしれない）
    var innerCamera: AVCaptureDevice?
    
    // 実際に使うのはどっち？使う方を入れる（もしかしたら無いかもしれない）
    var device: AVCaptureDevice?
    
    // キャプチャーした画面をアウトプットするための入れ物
    var photoOutput = AVCapturePhotoOutput()
    
    // カメラのセッティング
    func setupDevice() {
        // 設定を開始するよ！
        captureSession.beginConfiguration()
        // 画像の解像度（大きさ）
        captureSession.sessionPreset = .photo // 端末に依存する
        
        // MARK: -- カメラの設定
        // 組み込みカメラを使う
        // カメラはフロント（インナー）とバックがある
        // 広角カメラが条件でデバイスを探してもらう
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
        
        // 条件を満たしたデバイスを取得する（複数あるかもしれない）
        let devices = deviceDiscoverySession.devices
        // 取得したデバイスを振り分ける。もしかしたら両方ないかもしれない。
        for device in devices {
            if device.position == .back {
                mainCamera = device
            } else if device.position == .front {
                innerCamera = device
            }
        }
        
        // 実際に起動するカメラは、背面が優先。インナーは背面がなかったら使う。
        device = mainCamera == nil ? innerCamera : mainCamera
        
        // MARK: -- 出力の設定
        guard captureSession.canAddOutput(photoOutput) else {
            captureSession.commitConfiguration()
            return
        }
        // ここから下は実行されないかもしれない
        // セッションが使うアウトプットの設定
        captureSession.addOutput(photoOutput)
        
        // MARK: -- 入力の設定
        if let device = device {
            guard let captureDeviceInput = try? AVCaptureDeviceInput(device: device),
                  captureSession.canAddInput(captureDeviceInput) else {
                captureSession.commitConfiguration()
                return
            }
            // セッションが使うインプットの設定
            captureSession.addInput(captureDeviceInput)
        }
        // 設定を終えるよ！設定はコミットするよ！
        captureSession.commitConfiguration()
    }
    
    func run() {
        DispatchQueue(label: "Background", qos: .background).async {
            self.captureSession.startRunning()
        }
    }
    
}

// classの継承をextensionに書くことができない
extension ViewModel: AVCapturePhotoCaptureDelegate {
    
    // 撮影に関連する一連の処理が終わったあとに実行する処理
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        // TODO: 後で書く
        // 撮影した写真をディスプレイに表示する？
    }
    
    // 写真をキャプチャーする直前に動作する（シャッター音）
    func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        // シャッター音を消す
        AudioServicesDisposeSystemSoundID(1108)
        // あるいは、シャッター音を他の音に変更する
        AudioServicesPlaySystemSound(1109)
    }
    
    // 写真をキャプチャー終わったら何をするか処理を書く
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        // 写真の保存処理
        PHPPhotoLibrary.requestAythorization(for: .addOnly) { status in
            gua rd status == .authorized else { return
                //PHPPhotoLibraryのあれこれにアクセスできるようになる
                //PHPPhotoLibraryに変更を要求する。非同期
                PHPPhotoLibrary.shared().performChanges {
                    //PHPPhotoLibraryに保存するリクエスト
                    let creationRequest = PHAssetCreationRequest.forAsset()
                    //リクエストに素材を渡す
                    //imageDataはオプショナルでデータがないかもしれない。
                    guard let imageData = self.imageData else { return }
                    creationRequest.addResource(with: .photo, data: )
                    
                    
                    
                }
            }
        }
    }
    
    // 写真を撮る
    func takePhoto() {
        // キャプチャーに関する設定
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
}
