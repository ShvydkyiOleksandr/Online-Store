//
//  NewsView.swift
//  Online Store
//
//  Created by Олександр Швидкий on 11.01.2023.
//

import SwiftUI

struct NewsView: View {
    @EnvironmentObject private var newsVM: NewsViewModel
    @State private var selectedNews: News?
    
    var body: some View {
        NavigationView {
            Group {
                if newsVM.news.isEmpty {
                    Text("There are not news")
                        .font(.title2)
                } else {
                    ScrollView(showsIndicators: false) {
                        ForEach(newsVM.news) { news in
                            MiniCardNews(selectedNews: $selectedNews, news: news)
                                .fullScreenCover(item: $selectedNews, content: { news in
                                    FullNewsView(news: news)
                                })
                        }
                    }
                    .padding(.horizontal, 5)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .background(Color("background"))
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("News")
                        .font(.title2.bold())
                }
                
                ToolbarItem(placement: .navigationBarTrailing) { MobButton() }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
            .environmentObject(NewsViewModel(isInPreview: true))
    }
}
