//
//  ImagePicker.swift
//  FilterSample
//
//  Created by cmStudent on 2022/08/12.
//

import Foundation
import SwiftUI

struct ImagePicker {
    @Binding var isShown: Bool
    @Binding var image: UIImage?
    
    var sourceType: UIImagePickerController.SourceType
}

extension ImagePicker: UIViewControllerRepresentable{
    typealias UIViewControllerType = UIImagePickerController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>)
    -> UIImagePickerController {
        
        // ImagePickerを作成
        let imagePicker = UIImagePickerController()
        // sourceTypeを代入
        imagePicker.sourceType = sourceType
        // coordinatorをdelegateに代入
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) {}
    
    // 任意のインスタンスをCoordinatorとして返すことができる
    // UIImagePickerControllerDelegateを準拠する型のインスタンスを返している
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
}

final class Coordinator: NSObject,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    // ImagePickerのプロパティにアクセスするため
    let parent: ImagePicker
    
    init(parent: ImagePicker) {
        self.parent = parent
    }
    // UIImagePickerControllerDelegateメソッドを実装
    // Image Pickerで画像が選ばれた場合に呼ばれるメソッド
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info:
    [UIImagePickerController.InfoKey : Any]) {
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        else { return }
        // imageを更新
        parent.image = originalImage
        // Image Pickerを閉じる
        parent.isShown = false
    }
    
    // 閉じるボタンがタップされたときに呼ばれるメソッド
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Image Pickerを閉じる
        parent.isShown = false
    }
}
