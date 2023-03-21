//
//  LogoView.swift
//  Online Store
//
//  Created by Олександр Швидкий on 11.01.2023.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        Image("OnlineStore")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .border()
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
            .padding()
    }
}
