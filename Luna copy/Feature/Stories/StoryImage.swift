//
//  StoryImage.swift
//  Luna
//
//  Created by Ned O'Rourke on 19/4/22.
//

import SwiftUI

struct StoryImage<Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Placeholder
    private let image: (UIImage) -> Image
    
    init(
        url: URL,
        @ViewBuilder placeholder: () -> Placeholder,
        @ViewBuilder image: @escaping (UIImage) -> Image = Image.init(uiImage:)
    ) {
        self.placeholder = placeholder()
        self.image = image
        _loader = StateObject(wrappedValue: ImageLoader(url: url, cache: Environment(\.imageCache).wrappedValue))
    }
    
    var body: some View {
        content
            .onAppear(perform: loader.load)
    }
    
    private var content: some View {
        Group {
            if loader.image != nil {
                image(loader.image!)
                    .resizable()
//                    .scaledToFit()
//                    .frame(width: UIScreen.main.bounds.width)
//                    .clipped()
//                    .cornerRadius(15)
//                    .cornerRadius(10)
//                    .scaledToFill()
//                    .scaledToFill()
//                    .clipped()
            } else {
                placeholder
            }
        }
    }
}

//struct StoryImage2<Placeholder: View>: View {
//    @StateObject private var loader: ImageLoader
//    private let placeholder: Placeholder
//    private let image: (UIImage) -> Image
//
//    init(
//        url: URL,
//        @ViewBuilder placeholder: () -> Placeholder,
//        @ViewBuilder image: @escaping (UIImage) -> Image = Image.init(uiImage:)
//    ) {
//        self.placeholder = placeholder()
//        self.image = image
//        _loader = StateObject(wrappedValue: ImageLoader(url: url, cache: Environment(\.imageCache).wrappedValue))
//    }
//
//    var body: some View {
//        content
//            .onAppear(perform: loader.load)
//    }
//
//    private var content: some View {
//        Group {
//            if loader.image != nil {
//                image(loader.image!)
//                    .resizable()
////                    .scaledToFit()
////                    .frame(width: UIScreen.main.bounds.width)
////                    .clipped()
////                    .cornerRadius(15)
////                    .cornerRadius(10)
////                    .scaledToFill()
////                    .scaledToFill()
////                    .clipped()
//            } else {
//                placeholder
//            }
//        }
//    }
//}
