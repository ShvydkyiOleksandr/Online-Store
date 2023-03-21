//
//  ChooseCityButton.swift
//  Online Store
//
//  Created by Олександр Швидкий on 13.02.2023.
//

import SwiftUI

struct ChooseCityButton: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var showPicker: Bool
    @Binding var selectedCity: String
    let isChecking: Bool
    var isCityNameValid: Bool { ValidationManager.isCityNameValid(cityName: selectedCity) }
    
    init(isChecking: Bool = false, showPicker: Binding<Bool>, selectedCity: Binding<String>) {
        self.isChecking = isChecking
        _showPicker = showPicker
        _selectedCity = selectedCity
    }
    
    var body: some View {
        Button {
            withAnimation { showPicker.toggle() }
        } label: {
            HStack {
                Text("Choose city")
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .border(radius: 10)
            .buttonStyle(.plain)
            .overlay {
                HStack {
                    Text(selectedCity)
                    
                    VStack {
                        Image(systemName: "chevron.up")
                        Image(systemName: "chevron.down")
                    }
                    .font(.some(.caption2))
                }
                .padding(.horizontal, 5)
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(isCityNameValid ? .clear : (colorScheme == .light ? .white : .black))
                        .if(isChecking) { $0.isCorrectShadow(isCorrect: isCityNameValid) }
                }
                .padding(.trailing, 6)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
}

struct ChooseCityButton_Previews: PreviewProvider {
    static var previews: some View {
        ChooseCityButton(showPicker: .constant(true), selectedCity: .constant("None"))
            .environmentObject(BasketViewModel(isInPreview: true))
    }
}
