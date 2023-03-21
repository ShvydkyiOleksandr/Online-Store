//
//  KeyboardToolbar.swift
//  Online Store
//
//  Created by Олександр Швидкий on 17.02.2023.
//

import SwiftUI

enum FocusedField {
    case firstName, lastName
    case password, repeatedPassword
    case email
    case phoneNumber
    case street, apartment, building
    case cityName
    case novaPoshtaNumber
}

struct KeyboardToolbar: View {
    @EnvironmentObject private var basketVM: BasketViewModel
    @FocusState var focusedField: FocusedField?
    let viewType: Views
    
    enum Views {
        case userBasket
        case registrationView
        case profileView
    }
    
    var body: some View {
        HStack {
            Button {
                withAnimation { previous() }
            } label: {
                Image(systemName: "arrow.left")
            }
            
            Button {
                withAnimation { next() }
            } label: {
                Image(systemName: "arrow.right")
            }
            
            Spacer()
            
            Button {
                focusedField = nil
            } label: {
                Image(systemName: "checkmark")
            }
        }
        .foregroundColor(.blue)
        .font(.title3.bold())
    }
    
    private func next() {
        switch viewType {
        case .userBasket:
            switch focusedField {
            case .some(.firstName): focusedField = .lastName
            case .some(.lastName): focusedField = .email
            case .some(.email): focusedField = .phoneNumber
            case .some(.phoneNumber): focusedField = basketVM.deliveryType == .novaPoshta ? .novaPoshtaNumber : .street
            case .some(.novaPoshtaNumber): focusedField = nil
            case .some(.street): focusedField = .building
            case .some(.building): focusedField = .apartment
            case .some(.apartment): focusedField = nil
            default: return
            }
        case .registrationView:
            switch focusedField {
            case .some(.firstName): focusedField = .lastName
            case .some(.lastName): focusedField = .email
            case .some(.email): focusedField = .password
            case .some(.password): focusedField = .repeatedPassword
            case .some(.repeatedPassword): focusedField = .phoneNumber
            case .some(.phoneNumber): focusedField = .street
            case .some(.street): focusedField = .building
            case .some(.building): focusedField = .apartment
            case .some(.apartment): focusedField = .novaPoshtaNumber
            case .some(.novaPoshtaNumber): focusedField = nil
            default: return
            }
        case .profileView:
            switch focusedField {
            case .some(.firstName): focusedField = .lastName
            case .some(.lastName): focusedField = .phoneNumber
            case .some(.phoneNumber): focusedField = .street
            case .some(.street): focusedField = .building
            case .some(.building): focusedField = .apartment
            case .some(.apartment): focusedField = .novaPoshtaNumber
            case .some(.novaPoshtaNumber): focusedField = nil
            default: return
            }
        }
    }
    
    private func previous() {
        switch viewType {
        case .userBasket:
            switch focusedField {
            case .some(.firstName): focusedField = nil
            case .some(.lastName): focusedField = .firstName
            case .some(.email): focusedField = .lastName
            case .some(.phoneNumber): focusedField = .email
            case .some(.novaPoshtaNumber): focusedField = .phoneNumber
            case .some(.street): focusedField = .phoneNumber
            case .some(.building): focusedField = .street
            case .some(.apartment): focusedField = .building
            default: return
            }
        case .registrationView:
            switch focusedField {
            case .some(.firstName): focusedField = nil
            case .some(.lastName): focusedField = .firstName
            case .some(.email): focusedField = .lastName
            case .some(.password): focusedField = .email
            case .some(.repeatedPassword): focusedField = .password
            case .some(.phoneNumber): focusedField = .repeatedPassword
            case .some(.street): focusedField = .phoneNumber
            case .some(.building): focusedField = .street
            case .some(.apartment): focusedField = .building
            case .some(.novaPoshtaNumber): focusedField = .apartment
            default: return
            }
        case .profileView:
            switch focusedField {
            case .some(.firstName): focusedField = nil
            case .some(.lastName): focusedField = .firstName
            case .some(.phoneNumber): focusedField = .lastName
            case .some(.street): focusedField = .phoneNumber
            case .some(.building): focusedField = .street
            case .some(.apartment): focusedField = .email
            case .some(.novaPoshtaNumber): focusedField = .apartment
            default: return
            }
        }
    }
}

struct KeyboardToolbar_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardToolbar(viewType: .userBasket)
    }
}
