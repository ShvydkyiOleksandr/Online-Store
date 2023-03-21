//
//  ChooseDeliveryView.swift
//  Online Store
//
//  Created by Олександр Швидкий on 12.01.2023.
//

import SwiftUI

struct ChooseDeliveryView: View {
    @EnvironmentObject private var basketVM: BasketViewModel
    @FocusState var focusedField: FocusedField?
    @Binding var showPicker: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("Delivery type:")
                    .font(.title3.bold())
                
                Picker("Delivery type", selection: $basketVM.deliveryType) {
                    ForEach(Order.DeliveryType.allCases) {
                        Text($0.rawValue)
                    }
                }
                .labelsHidden()
                .frame(maxWidth: .infinity, alignment: .trailing)
                .tint(.accentColor)
            }
            
            ChooseCityButton(isChecking: true, showPicker: $showPicker, selectedCity: $basketVM.selectedCity)
            
            Group {
                if basketVM.deliveryType == .novaPoshta {
                    TextField("Nova Poshta number", text: $basketVM.novaPoshtaNumber)
                        .innerShadowStyle(isCorrect: basketVM.isNovaPoshtaNumberValid)
                        .textContentType(.telephoneNumber)
                        .focused($focusedField, equals: .novaPoshtaNumber)
                        .keyboardType(.phonePad)
                } else {
                    TextField("Street name", text: $basketVM.street)
                        .textContentType(.fullStreetAddress)
                        .focused($focusedField, equals: .street)
                        .innerShadowStyle(isCorrect: !basketVM.street.isEmpty)
                    
                    HStack {
                        TextField("Bldg. number", text: $basketVM.building)
                            .textContentType(.fullStreetAddress)
                            .focused($focusedField, equals: .building)
                            .innerShadowStyle(isCorrect: !basketVM.building.isEmpty)
                        
                        TextField("Apt. number", text: $basketVM.apartment)
                            .textContentType(.fullStreetAddress)
                            .focused($focusedField, equals: .apartment)
                            .innerShadowStyle(isCorrect: !basketVM.apartment.isEmpty)
                    }
                }
            }
            .foregroundColor(.accentColor)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
        }
        .border(radius: 20, padding: 10)
    }
}

struct ChooseDeliveryView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseDeliveryView(showPicker: .constant(true))
            .environmentObject(BasketViewModel(isInPreview: true))
    }
}
