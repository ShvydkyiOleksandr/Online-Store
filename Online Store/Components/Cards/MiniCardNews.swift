//
//  MiniCardNews.swift
//  Online Store
//
//  Created by Олександр Швидкий on 12.01.2023.
//

import SwiftUI
import CachedAsyncImage

struct MiniCardNews: View {
    @EnvironmentObject private var newsVM: NewsViewModel
    @Binding var selectedNews: News?
    let news: News
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                if !newsVM.isViewed(news: news) {
                    Image(systemName: "circle.fill")
                        .foregroundColor(.green)
                }
        
                Text(news.name).bold()
            }
            
            if let imageUrl = news.previewImageUrl {
                CachedAsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } placeholder: {
                    ProgressView().padding()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
            }
            
            Text(news.shortDescription)
            
            Text(news.formattedDate)
            
            BlackButton(buttonName: "Detail") { selectedNews = news }
        }
        .border(padding: 10)
    }
}

struct MiniCardNews_Previews: PreviewProvider {
    static var previews: some View {
        MiniCardNews(selectedNews: .constant(previewNews), news: previewNews)
            .environmentObject(NewsViewModel(isInPreview: true))
    }
}
