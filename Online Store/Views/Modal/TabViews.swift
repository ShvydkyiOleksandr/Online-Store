//
//  ToolbarView .swift
//  Online Store
//
//  Created by Олександр Швидкий on 11.01.2023.
//

import SwiftUI

enum Tabs: String {
    case mainView, newsView, likeView, profileView, userBasket
}

struct TabViews: View {
    @StateObject private var newsVM: NewsViewModel
    @StateObject private var productsVM: ProductsViewModel
    @StateObject private var brandsVM = BrandsViewModel()
    @StateObject private var basketVM: BasketViewModel
    @StateObject private var proceduresVM = ProceduresViewModel()
    @StateObject private var ordersVM: OrdersViewModel
    @SceneStorage("selectedTab") var selectedTab: Tabs = .mainView
    
    init(isInPreview: Bool = false) {
        _newsVM = StateObject(wrappedValue: NewsViewModel(isInPreview: isInPreview))
        _basketVM = StateObject(wrappedValue: BasketViewModel(isInPreview: isInPreview))
        _ordersVM = StateObject(wrappedValue: OrdersViewModel(isInPreview: isInPreview))
        _productsVM = StateObject(wrappedValue: ProductsViewModel(isInPreview: isInPreview))
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MainView(brandsVM: brandsVM)
                .tabItem {
                    Label("Main", systemImage: "house")
                }
                .environmentObject(proceduresVM)
                .tag(Tabs.mainView)
            
            NewsView()
                .tabItem {
                    Label("News", systemImage: "newspaper")
                }
                .badge(newsVM.badge?.formatted())
                .environmentObject(newsVM)
                .tag(Tabs.newsView)
            
            LikeView()
                .tabItem {
                    Label("Likes", systemImage: "hand.thumbsup")
                }
                .badge(productsVM.badge?.formatted())
                .tag(Tabs.likeView)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .environmentObject(ordersVM)
                .tag(Tabs.profileView)
            
            UserBasket()
                .tabItem {
                    Label("Basket", systemImage: "basket")
                }
                .badge(basketVM.badge?.formatted())
                .tag(Tabs.userBasket)
        }
        .environmentObject(productsVM)
        .environmentObject(basketVM)
//        .task {
//            await uploadStoreData(
//                productsVM: productsVM,
//                newsVM: newsVM,
//                proceduresVM: proceduresVM,
//                brandsVM: brandsVM)
//        }
    }
}

struct TabViews_Previews: PreviewProvider {
    static var authManager: AuthManager {
        let manager = AuthManager()
        manager.currentUser = previewUser
        return manager
    }
    
    static var previews: some View {
        TabViews(isInPreview: true)
            .environmentObject(authManager)
    }
}
