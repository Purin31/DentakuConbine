//
//  FilterType.swift
//  FilterSample
//
//  Created by cmStudent on 2022/08/12.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

enum FilterType: String {
    case pixellate = "モザイク"
    case sepiaTone = "セピア"
    case sharpenLuminance = "シャープ"
    case photoEffectMono = "モノクロ"
    case gaussianBlur = "ブラー"
    
    private func makeFilter(inputImage: CIImage?) -> CIFilter {
        switch self {
        case .pixellate:
            let currentFilter = CIFilter.pixellate()
            currentFilter.inputImage = inputImage
            currentFilter.scale = 40
            return currentFilter
        case .sepiaTone:
            let currentFilter = CIFilter.sepiaTone()
            currentFilter.inputImage = inputImage
            currentFilter.intensity = 1
            return currentFilter
        case .sharpenLuminance:
            let currentFilter = CIFilter.sharpenLuminance()
            currentFilter.inputImage = inputImage
            currentFilter.sharpness = 0.5
            currentFilter.radius = 100
            return currentFilter
        case .photoEffectMono:
            let currentFilter = CIFilter.photoEffectMono()
            currentFilter.inputImage = inputImage
            return currentFilter
        case .gaussianBlur:
            let currentFilter = CIFilter.gaussianBlur()
            currentFilter.inputImage = inputImage
            currentFilter.radius = 10
            return currentFilter
        }
        
    }
    
    func filter(inputImage: UIImage) -> UIImage? {
        let beginImage = CIImage(image: inputImage)
        // Core Image処理の評価コンテキストを作成
        let context = CIContext()
        // makeFilterは後で解説
        let currentFilter = makeFilter(inputImage: beginImage)
        
        // フィルター加工されたCIImageを取得する。失敗したらnilを返す
        guard let outputImage = currentFilter.outputImage
        else { return nil }
        
        // CIImageからCGImageを取得する
        if let cgimg = context.createCGImage(outputImage,from: outputImage.extent) {
            
            // CGImageからUIImageを作成する
            // CGImageは向きの情報が失われているのでorientation引数を指定する
            return UIImage(cgImage: cgimg, scale: 0,
                           orientation: inputImage.imageOrientation)
        } else {
            return nil
        }
    }
    
}
