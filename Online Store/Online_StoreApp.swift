//
//  Online_StoreApp.swift
//  Online Store
//
//  Created by Олександр Швидкий on 11.01.2023.
//

import SwiftUI
import FirebaseCore

@main
struct Online_StoreApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject var networkReachability = NetworkReachability()
    @StateObject var authManager = AuthManager()
    @StateObject var modalManager = ModalManager()
    @StateObject var alertManager = AlertManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(networkReachability)
                .environmentObject(authManager)
                .environmentObject(modalManager)
                .environmentObject(alertManager)
        }
    }
}
