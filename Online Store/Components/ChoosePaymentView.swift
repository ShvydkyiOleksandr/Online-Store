//
//  ChoosePaymentView.swift
//  Online Store
//
//  Created by Олександр Швидкий on 12.01.2023.
//

import SwiftUI

struct ChoosePaymentView: View {
    @EnvironmentObject var basketVM: BasketViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Payment type:")
                .font(.title3.bold())
                .padding(.leading, 10)
            
            Picker("Payment type:", selection: $basketVM.paymentType) {
                ForEach(Order.PaymentType.allCases) {
                    Text($0.rawValue)
                }
            }
            .labelsHidden()
            .tint(.accentColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .border(radius: 20, padding: 10)
    }
}

struct ChoosePaymentView_Previews: PreviewProvider {
    static var previews: some View {
        ChoosePaymentView()
            .environmentObject(BasketViewModel(isInPreview: true))
    }
}
