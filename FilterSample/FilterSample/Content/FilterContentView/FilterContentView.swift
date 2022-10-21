//
//  FilterContentView.swift
//  FilterSample
//
//  Created by cmStudent on 2022/08/12.
//

import SwiftUI

struct FilterContentView: View {
    @StateObject private var viewModel = FilterContentViewModel()
    var body: some View {
        NavigationView {
            ZStack{
                if let filterdImage = viewModel.filteredImage {
                    Image(uiImage: filterdImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .onTapGesture {
                            withAnimation {
                                viewModel.isShowBanner.toggle()
                            }
                        }
                } else {
                    EmptyView()
                }
                FilterBannerView(isShowBanner: $viewModel.isShowBanner,  applyingFilter: $viewModel.applyingFilter)
//                    .offset(x: 0, y: viewModel.isShowBanner ? 0 : 400)
//                    .edgesIgnoringSafeArea(.bottom)
            }
            .navigationTitle("Filter APP")
            .navigationBarItems(trailing: HStack{
                Button{
                    viewModel.apply(.tappedSaveIcon)
                } label: {
                    Image(systemName: "square.and.arrow.down")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                }
                Button{ viewModel.apply(.tappedImageIcon) } label: {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                }
            })
            .onAppear{
                viewModel.apply(.onAppear)
            }
            .actionSheet(isPresented: $viewModel.isShowActionSheet){
                actionSheet
            }
            .sheet(isPresented: $viewModel.isShowImagePickerView){
                ImagePicker(isShown: $viewModel.isShowImagePickerView,
                            image: $viewModel.image,
                            sourceType: viewModel.selectedSourceType)
            }
            .alert(isPresented: $viewModel.isShowAlert){
                Alert(title: Text(viewModel.alertTitle))
            }
        }
    }
    
    var actionSheet: ActionSheet {
        var buttons: [ActionSheet.Button] = []
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraButton = ActionSheet.Button.default(Text("写真を撮る")){
                viewModel.apply(.tappedActionSheet(selectType: .camera))
            }
            buttons.append(cameraButton)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryButton = ActionSheet.Button.default(Text("アルバムから選択")){
                viewModel.apply(.tappedActionSheet(selectType: .photoLibrary))
            }
            buttons.append(photoLibraryButton)
        }
        let cancelButton = ActionSheet.Button.default(Text("キャンセル")){}
        buttons.append(cancelButton)
        
        let actionSheet = ActionSheet(title: Text("画像選択"),message: nil, buttons: buttons)
        
        return actionSheet
    }
}

struct FilterContentView_Previews: PreviewProvider {
    static var previews: some View {
        FilterContentView()
    }
}
