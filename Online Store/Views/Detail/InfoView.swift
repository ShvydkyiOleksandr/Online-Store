//
//  InfoView.swift
//  Online Store
//
//  Created by Олександр Швидкий on 11.01.2023.
//

import SwiftUI

struct InfoView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Text("Info for clients")
                .font(.title2)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        WhiteButton(buttonName: "back") { dismiss() }.frame(width: 80)
                    }
                    
                    ToolbarItem(placement: .principal) { Text("For clients").font(.title2.bold()) }
                    
                    ToolbarItem(placement: .navigationBarTrailing) { MobButton() }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
