//
//  FilterBannerView.swift
//  FilterSample
//
//  Created by cmStudent on 2022/08/12.
//

import SwiftUI

struct FilterBannerView: View {
    @State var selectedFilter: FilterType? = nil
    @Binding var isShowBanner: Bool
    @Binding var applyingFilter: FilterType?
    var body: some View {
        GeometryReader { geometry in
            VStack{
                Spacer()
                VStack{
                    FilterTitleView(title: selectedFilter?.rawValue)
                    FilterIconContainerView(selectedFilter: $selectedFilter)
                    FilterButtonContainerView(isShowBanner: $isShowBanner,
                                              selectedFilter: $selectedFilter,
                                              applyingFilter: $applyingFilter)
                }
            }
            .background(Color.black.opacity(0.3))
            .foregroundColor(.white)
            .offset(x: 0, y: isShowBanner ? 0 : geometry.size.height)
            
        }
    }
}

//struct FilterBannerView_Previews: PreviewProvider {
//    static var previews: some View {
//        FilterBannerView(isShowBanner: .constant(true))
//    }
//}

struct FilterTitleView: View {
    let title: String?
    var body: some View {
        Text("\(title ?? "フィルターを選択")")
            .font(.title)
            .fontWeight(.bold)
            .padding(.top)
    }
}

struct FilterImage: View {
    @State private var image: Image?
    let filterType: FilterType
    @Binding var selectedFilter: FilterType?
    
    let uiImage: UIImage = UIImage(named: "センチュリー")!
    var body: some View {
        Button(action: {
            selectedFilter = filterType
        }){
            image?
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaledToFit()
        }
        .frame(width: 70, height: 70)
        .border(Color.primary, width: selectedFilter == filterType ? 4 : 0)
        .onAppear {
            if let outputImage = filterType.filter(inputImage: uiImage) {
                self.image = Image(uiImage: outputImage)
            }
        }
    }
}

struct FilterIconContainerView: View {
    @Binding var selectedFilter: FilterType?
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            
            HStack {
                FilterImage(filterType: .pixellate,selectedFilter: $selectedFilter)
                
                FilterImage(filterType: .sepiaTone,selectedFilter: $selectedFilter)
                
                FilterImage(filterType: .sharpenLuminance,selectedFilter: $selectedFilter)
                
                FilterImage(filterType: .photoEffectMono,selectedFilter: $selectedFilter)
                
                FilterImage(filterType:.gaussianBlur,selectedFilter: $selectedFilter)
            }
            .padding([.leading, .trailing], 16)
            
        }
    }
}

struct FilterButtonContainerView: View {
    @Binding var isShowBanner: Bool
    @Binding var selectedFilter: FilterType?
    @Binding var applyingFilter: FilterType?
    var body: some View {
        HStack {
            Button(action: {
                withAnimation{
                    isShowBanner = false
                    selectedFilter = nil
                }
            }){
                Image(systemName: "xmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
                    .padding()
            }
            Spacer()
            Button(action: {
                isShowBanner = false
                applyingFilter = selectedFilter
                selectedFilter = nil
            }){
                Image(systemName: "checkmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
                    .padding()
            }
        }
    }
}
