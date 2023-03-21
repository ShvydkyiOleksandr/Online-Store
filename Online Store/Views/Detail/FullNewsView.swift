//
//  FullNewsView.swift
//  Online Store
//
//  Created by Олександр Швидкий on 11.01.2023.
//

import SwiftUI
import CachedAsyncImage

struct FullNewsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var newsVM: NewsViewModel
    let news: News
    
    var body: some View {
        NavigationView {
            Form {
                Text(news.name).font(.title3.bold())
                
                if let imageUrl = news.imageUrl {
                    CachedAsyncImage(url: imageUrl) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    } placeholder: {
                        ProgressView().padding()
                    }
                }
                
                Text(news.formattedDate)
                
                Text(news.formattedDescription)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    WhiteButton(buttonName: "back") { dismiss() }.frame(width: 80)
                }
                
                ToolbarItem(placement: .principal) { Text("News").font(.title2.bold()) }
                ToolbarItem(placement: .navigationBarTrailing) { MobButton() }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .onAppear { newsVM.addToViewedNews(news: news) }
        }
    }
}

struct FullNewsView_Previews: PreviewProvider {
    static var previews: some View {
        FullNewsView(news: previewNews)
            .environmentObject(NewsViewModel(isInPreview: true))
    }
}
