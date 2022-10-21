//
//  FilterContentViewModel.swift
//  FilterSample
//
//  Created by cmStudent on 2022/08/12.
//

import SwiftUI
import Combine

final class FilterContentViewModel: NSObject, ObservableObject {
    enum Inputs {
        case onAppear
        case tappedActionSheet(selectType: UIImagePickerController.SourceType)
        case tappedSaveIcon
        case tappedImageIcon
    }
    
    
    @Published var image: UIImage?
    @Published var isShowActionSheet = false
    @Published var isShowImagePickerView = false
    @Published var isShowBanner = false
    @Published var filteredImage: UIImage?
    @Published var selectedSourceType: UIImagePickerController.SourceType = .camera
    
    @Published var applyingFilter: FilterType? = nil
    
    var cancellables: [Cancellable] = []
    
    var alertTitle: String = ""
    
    @Published var isShowAlert = false
    
    override init() {
        super.init()
        // 新しい画像に更新する
        let imageCancellable = $image.sink { [weak self]
            (uiimage) in
            guard let self = self, let uiimage = uiimage else { return }
            
            self.filteredImage = uiimage
        }
        let filterCanncellable = $applyingFilter.sink{ [weak self] filterType in
            guard let self = self,
                  let filterType = filterType,
                    let image = self.image else {
                        return
                    }
            guard let filteredUIImage = self.updateImage(with: image, type: filterType) else { return }
            self.filteredImage = filteredUIImage

        }
        cancellables.append(imageCancellable)
        cancellables.append(filterCanncellable)
    }
    
    private func updateImage(with image: UIImage, type filter: FilterType) ->
    UIImage? {
        return filter.filter(inputImage: image)
    }
    
    func apply(_ inputs: Inputs) {
        switch inputs {
        case .onAppear:
            if image == nil {
                isShowActionSheet = true
            }
        case .tappedActionSheet(let sourceType):
            selectedSourceType = sourceType
            isShowImagePickerView = true
            
        case .tappedSaveIcon:
            UIImageWriteToSavedPhotosAlbum(filteredImage!, self, #selector(imageSaveCompletion(_:didFinishSavingWithError:contextInfo:)), nil)
            
        case .tappedImageIcon:
            isShowActionSheet = true
        }
   
        
    }
    
    @objc func imageSaveCompletion(_ image: UIImage,
                                   didFinishSavingWithError error: Error?,
                                   contextInfo: UnsafeRawPointer) {
        alertTitle = error == nil ? "画像が保存されました" : error?.localizedDescription ?? ""
        
        isShowAlert = true
    }
}
