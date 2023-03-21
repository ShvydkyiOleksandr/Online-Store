//
//  DiscloseListButton.swift
//  Online Store
//
//  Created by Олександр Швидкий on 02.03.2023.
//

import SwiftUI

struct DiscloseListButton: View {
    @Binding var show: Bool
    let isListEmpty: Bool
    let title: String
    let titleForEmptyList: String
    
    var body: some View {
        Button {
            withAnimation(.spring()) {
                show.toggle()
            }
        } label: {
            Group {
                if isListEmpty {
                    Text(titleForEmptyList)
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    HStack {
                        Text(title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Image(systemName: "chevron.right")
                            .rotationEffect(Angle(degrees: show ? 90 : 0))
                    }
                }
            }
            .font(.title3.bold())
            .border(radius: !isListEmpty && !show ? 15 : 20, padding: 10)
        }
    }
}

struct DiscloseListButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            DiscloseListButton(
                show: .constant(false),
                isListEmpty: false,
                title: "Orders",
                titleForEmptyList: "Orders is empty")
            
            DiscloseListButton(
                show: .constant(true),
                isListEmpty: true,
                title: "Orders",
                titleForEmptyList: "Orders is empty")
        }
    }
}

