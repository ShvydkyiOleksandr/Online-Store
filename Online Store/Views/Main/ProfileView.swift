//
//  ProfileView.swift
//  Online Store
//
//  Created by Олександр Швидкий on 11.01.2023.
//

import SwiftUI
import PhotosUI
import CachedAsyncImage

struct ProfileView: View {
    @EnvironmentObject private var authManager: AuthManager
    @EnvironmentObject private var modalManager: ModalManager
    @EnvironmentObject private var alertManager: AlertManager
    @StateObject private var profileVM = ProfileViewModel()
    @FocusState private var focusedField: FocusedField?
    @State private var showOrdersView = false
    @State private var showInfoView = false
    @State private var showPicker = false
    
    var currentUser: User { authManager.currentUser }
    
    var body: some View {
        NavigationView {
            List {
                if profileVM.isEditing {
                    editingProfileImage
                    
                    Group {
                        basicInfoTextFields
                        addressesTextFields
                    }
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                } else {
                    profileImage
                    basicInfo
                    addresses
                    setting
                }
            }
            .if(profileVM.showProgressView) { view in
                view
                    .blur(radius: 3)
                    .overlay { ProgressView() }
                    .disabled(profileVM.showProgressView)
            }
            .listStyle(.sidebar)
            .animation(.default, value: profileVM.isEditing)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .background(Color("background"))
            .customPicker(
                show: $showPicker,
                selection: $profileVM.selectedCity,
                data: User.Addresses.getCities()
            )
            .toolbar { toolbar }
            .onAppear() { profileVM.setupUserInfo(user: currentUser) }
        }
    }
    
    var profileImage: some View {
        Group {
            if let imageUrl = currentUser.imageUrl {
                CachedAsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .mask { RoundedRectangle(cornerRadius: 10, style: .continuous) }
                } placeholder: {
                    ProgressView().padding()
                }
            } else {
                Image(systemName: "person")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .frame(width: 100, height: 100)
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    var basicInfo: some View {
        Section("Basic info") {
            Text(currentUser.fullName).font(.title3.bold())
            Text("**Phone:** \(currentUser.phone ?? "")")
            Text("**Email:** \(currentUser.email)")
        }
    }
    
    var addresses: some View {
        Section("Addresses") {
            Text("**City:** \(currentUser.addresses?.cityName ?? "")")
            Text("**Nova Poshta number:** \(currentUser.addresses?.novaPoshtaNumber ?? "")")
            Text("**Address:** \(currentUser.addresses?.addressString ?? "")")
        }
    }
    
    var editingProfileImage: some View {
        VStack {
            PhotosPicker(selection: $profileVM.selectedPhoto, matching: .images) {
                Text("Tap to choose" ).font(.title3.bold())
            }
            .onChange(of: profileVM.selectedPhoto) { newValue in
                profileVM.setSelectedPhoto()
            }
            
            if let selectedPhotoData = profileVM.selectedPhotoData, let image = UIImage(data: selectedPhotoData) {
                Image(uiImage: image)
                    .resizable()
                    .mask { RoundedRectangle(cornerRadius: 10, style: .continuous) }
                    .frame(width: 100, height: 100)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                profileImage
            }
        }
    }
    
    var basicInfoTextFields: some View {
        Section("Basic info") {
            HStack {
                TextField("First name", text: $profileVM.firstName)
                    .textContentType(.name)
                    .focused($focusedField, equals: .firstName)
                    .innerShadowStyle(isCorrect: profileVM.isFirstNameValid)
                
                TextField("Last name", text: $profileVM.lastName)
                    .textContentType(.name)
                    .focused($focusedField, equals: .lastName)
                    .innerShadowStyle(isCorrect: profileVM.isLastNameValid)
            }
            
            TextField("Phone", text: $profileVM.phone)
                .textContentType(.telephoneNumber)
                .focused($focusedField, equals: .phoneNumber)
                .keyboardType(.phonePad)
                .innerShadowStyle(isCorrect: profileVM.isPhoneNumberValid)
        }
    }
    
    var addressesTextFields: some View {
        Section("Addresses") {
            ChooseCityButton(showPicker: $showPicker, selectedCity: $profileVM.selectedCity)
            
            TextField("Street name", text: $profileVM.street)
                .textContentType(.fullStreetAddress)
                .focused($focusedField, equals: .street)
                .innerShadowStyle(isCorrect: profileVM.isStreetValid)
            
            HStack {
                TextField("Bldg. number", text: $profileVM.building)
                    .textContentType(.fullStreetAddress)
                    .focused($focusedField, equals: .building)
                    .innerShadowStyle(isCorrect: profileVM.isBuildingValid)
                
                TextField("Apt. number", text: $profileVM.apartment)
                    .textContentType(.fullStreetAddress)
                    .focused($focusedField, equals: .apartment)
                    .innerShadowStyle(isCorrect: profileVM.isApartmentValid)
            }
            
            TextField("Nova Poshta number", text: $profileVM.novaPoshtaNumber)
                .textContentType(.fullStreetAddress)
                .focused($focusedField, equals: .novaPoshtaNumber)
                .keyboardType(.phonePad)
                .innerShadowStyle()
        }
    }
    
    var setting: some View {
        Section("Settings") {
            VStack(spacing: 15) {
                WhiteButton(buttonName: "My orders") { showOrdersView.toggle() }
                    .sheet(isPresented: $showOrdersView) { OrdersView() }
                
                WhiteButton(buttonName: "For customer") { showInfoView.toggle() }
                    .sheet(isPresented: $showInfoView) { InfoView() }
                
                WhiteButton(buttonName: "Change password") { modalManager.activeModal = .changePasswordView }
                 
                BlackButton(buttonName: "LOG OUT") {
                    authManager.signOut(modalManager: modalManager, alertManager: alertManager)
                }
            }
        }
    }
    
    var toolbar: some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarLeading) {
                WhiteButton(buttonName: !profileVM.isEditing ? "edit" : "save") {
                    profileVM.saveChanges(authManager: authManager, alertManager: alertManager)
                }
            }
            
            ToolbarItem(placement: .principal) { Text("Profile").font(.title2.bold()) }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                if !profileVM.isEditing {
                    MobButton()
                } else {
                    WhiteButton(buttonName: "cancel") {
                        showPicker = false
                        profileVM.isEditing = false
                    }
                }
            }
            
            ToolbarItemGroup(placement: .keyboard) {
                KeyboardToolbar(focusedField: _focusedField, viewType: .profileView)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var authManager: AuthManager {
        let manager = AuthManager()
        manager.currentUser = previewUser
        return manager
    }
    
    static var previews: some View {
        ProfileView()
            .environmentObject(authManager)
            .environmentObject(OrdersViewModel(isInPreview: true))
            .environmentObject(AlertManager())
    }
}
