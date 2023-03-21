//
//  SplashView.swift
//  Online Store
//
//  Created by Олександр Швидкий on 11.01.2023.
//

import SwiftUI
import FirebaseAuth

struct SplashView: View {
    @EnvironmentObject private var networkReachability: NetworkReachability
    @EnvironmentObject private var modalManager: ModalManager
    @EnvironmentObject private var authManager: AuthManager
    @EnvironmentObject private var alertManager: AlertManager
    
    var body: some View {
        VStack {
            LogoView().padding(100)
            
            if !networkReachability.reachable {
                HStack {
                    Text("Attention, there is no Internet connection, turn on the Internet and try to log in again")
                        .border(padding: 10)
                    
                    Spacer()
                    
                    Button {
                        withAnimation { networkReachability.checkConnection()  }
                    } label: {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 40)
                            .overlay {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .foregroundColor(.white)
                                    .rotationEffect(Angle(degrees: -30))
                            }
                            .padding()
                    }
                }
                .padding()
            }
        }
        .onAppear { authManager.hideSplashView(modalManager: modalManager, alertManager: alertManager) }
        .onChange(of: networkReachability.reachable) { reachable in
            if reachable { authManager.hideSplashView(modalManager: modalManager, alertManager: alertManager) }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
            .background(Color("background"))
            .environmentObject(NetworkReachability())
            .environmentObject(ModalManager())
            .environmentObject(AuthManager())
            .environmentObject(AlertManager())
    }
}
