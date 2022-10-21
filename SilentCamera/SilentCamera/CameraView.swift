//
//  CameraView.swift
//  SilentCamera
//
//  Created by npc on 2022/06/14.
//

import SwiftUI
// カメラ機能を使うためのライブラリ
import Photos

class CameraView: UIView {
    fileprivate var viewModel: ViewModel!
    // MARK: -- Layerの設定
    // プレビュー用のレイヤー
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    // レイヤーの設定をする
    func setupLayer() {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: viewModel.captureSession)
        cameraPreviewLayer?.videoGravity = .resizeAspectFill
        // TODO: あとでやる
        cameraPreviewLayer?.connection?.videoOrientation = .portrait
        // 大きさどれくらい？？ どこの位置に表示する？表示する領域を教えて
        self.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: UIScreen.main.bounds.size)
        // LayerもViewと同じ大きさにする。
        cameraPreviewLayer?.frame = self.frame
        // オプショナルの値を安全に取り出す
        if let cameraPreviewLayer = cameraPreviewLayer {
            self.layer.addSublayer(cameraPreviewLayer)
        }
    }
}
// SwiftUIで使うためのRepresent
struct CameraViewRepresent: UIViewRepresentable {
    typealias UIViewType = CameraView
    let viewModel: ViewModel
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    func makeUIView(context: Context) -> CameraView {
        let view = CameraView()
        view.viewModel = viewModel
        view.viewModel.setupDevice()
        view.setupLayer()
        view.viewModel.run()
        return view
    }
    
    func updateUIView(_ uiView: CameraView, context: Context) {
        // 今回使わない
    }
}
