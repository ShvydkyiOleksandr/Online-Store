//
//  MobButton.swift
//  Online Store
//
//  Created by Олександр Швидкий on 11.01.2023.
//

import SwiftUI

struct MobButton: View {
    var body: some View {
        Button {
            callNumber(phoneNumber: "063-81-68-333")
        } label: {
            Text("mob")
                .font(.title3)
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .border()
        }
        .buttonStyle(.plain)
    }
    
    private func callNumber(phoneNumber: String) {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            let application: UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            } else {
                print("Can't open URL for phoneCallURL")
            }
        } else {
            print("Wrong URL!")
        }
    }
}

struct MobButton_Previews: PreviewProvider {
    static var previews: some View {
        MobButton()
    }
}
