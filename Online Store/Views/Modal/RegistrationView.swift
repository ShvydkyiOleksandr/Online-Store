//
//  RegistrationView.swift
//  Online Store
//
//  Created by Олександр Швидкий on 11.01.2023.
//

import SwiftUI
import FirebaseAuth

struct RegistrationView: View {
    @EnvironmentObject private var authManager: AuthManager
    @EnvironmentObject private var modalManager: ModalManager
    @EnvironmentObject private var alertManager: AlertManager
    @FocusState private var focusedField: FocusedField?
    @State private var showPicker = false
    @State private var showPassword = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    VStack(spacing: 10) {
                        Text("REGISTRATION").font(.title.bold())
                        
                        Group {
                            HStack {
                                TextField("First name", text: $authManager.firstName)
                                    .innerShadowStyle(isCorrect: authManager.isFirstNameValid)
                                    .textContentType(.name)
                                    .focused($focusedField, equals: .firstName)
                                
                                TextField("Last name", text: $authManager.lastName)
                                    .innerShadowStyle(isCorrect: authManager.isLastNameValid)
                                    .textContentType(.name)
                                    .focused($focusedField, equals: .lastName)
                            }
                            
                            TextField("Email", text: $authManager.email)
                                .innerShadowStyle(isCorrect: authManager.isUserEmailValid)
                                .textContentType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .focused($focusedField, equals: .email)
                                .keyboardType(.emailAddress)
                            
                            SecureFieldWithShow("Password", text: $authManager.password, show: $showPassword)
                                .innerShadowStyle(isCorrect: authManager.isPasswordValid)
                                .textContentType(.password)
                                .textInputAutocapitalization(.never)
                                .focused($focusedField, equals: .password)
                            
                            SecureField("Repeated password", text: $authManager.repeatedPassword)
                                .innerShadowStyle(isCorrect: authManager.passwordMatch)
                                .textContentType(.some(.password))
                                .textInputAutocapitalization(.never)
                                .focused($focusedField, equals: .repeatedPassword)
                            
                            TextField("Phone number", text: $authManager.phone)
                                .innerShadowStyle(isCorrect: authManager.isPhoneNumberValid)
                                .textContentType(.telephoneNumber)
                                .textInputAutocapitalization(.never)
                                .focused($focusedField, equals: .phoneNumber)
                                .keyboardType(.phonePad)
                            
                            Group {
                                ChooseCityButton(showPicker: $showPicker, selectedCity: $authManager.selectedCity)
                                
                                TextField("Street name", text: $authManager.street)
                                    .innerShadowStyle(isCorrect: authManager.isStreetValid)
                                    .textContentType(.fullStreetAddress)
                                    .focused($focusedField, equals: .street)
                                
                                HStack {
                                    TextField("Building number", text: $authManager.building)
                                        .innerShadowStyle(isCorrect: authManager.isBuildingValid)
                                        .textContentType(.fullStreetAddress)
                                        .textInputAutocapitalization(.never)
                                        .focused($focusedField, equals: .building)
                                    
                                    TextField("Apartment number", text: $authManager.apartment)
                                        .innerShadowStyle(isCorrect: authManager.isApartmentValid)
                                        .textContentType(.fullStreetAddress)
                                        .textInputAutocapitalization(.never)
                                        .focused($focusedField, equals: .apartment)
                                }
                                
                                TextField("Nova Poshta number", text: $authManager.novaPoshtaNumber)
                                    .innerShadowStyle()
                                    .textContentType(.streetAddressLine1)
                                    .textInputAutocapitalization(.never)
                                    .focused($focusedField, equals: .novaPoshtaNumber)
                                    .keyboardType(.numberPad)
                            }
                        }
                        .disableAutocorrection(true)
                        
                        BlackButton(buttonName: "Register") {
                            authManager.register(modalManager: modalManager, alertManager: alertManager)
                        }
                        .padding(.top, 5)
                    }
                    .border(padding: 10)
                    .padding(5)
                    
                    AgreementButton(isAgree: $authManager.isAgree)
                        .isCorrectShadow(isCorrect: authManager.isAgree)
                        .padding(.top, 10)
                        .padding(20)
                }
            }
            .customPicker(
                show: $showPicker,
                selection: $authManager.selectedCity,
                data: User.Addresses.getCities()
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    WhiteButton(buttonName: "back") { modalManager.activeModal = .loginView }
                }
                
                ToolbarItemGroup(placement: .keyboard) {
                    KeyboardToolbar(focusedField: _focusedField, viewType: .registrationView)
                }
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
            .background(Color("background"))
            .environmentObject(AuthManager())
            .environmentObject(ModalManager())
            .environmentObject(AlertManager())
    }
}
