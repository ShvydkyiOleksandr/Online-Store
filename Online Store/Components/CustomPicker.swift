//
//  Example.swift
//  Online Store
//
//  Created by Олександр Швидкий on 12.02.2023.
//

import SwiftUI

struct CustomPicker: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var pickerSelection: String
    @Binding var showPicker: Bool
    @State private var searchTerm: String = ""
    @FocusState var focusState
    let list: [String]
    
    var filtered: [String] {
        list.filter { searchTerm.isEmpty ? true : $0.lowercased().contains(searchTerm.lowercased()) }
    }
    
    var body: some View {
        if showPicker {
            GeometryReader { proxy in
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        TextField("Search", text: $searchTerm)
                            .focused($focusState)
                            .innerShadowStyle()
                            .onSubmit { focusState = false}
                        
                        Button {
                            showPicker.toggle()
                        } label: {
                            Text("Cancel")
                                .padding(.leading, 5)
                        }
                    }
                    .padding([.top, .horizontal], 10)
                    
                    
                    if filtered.isEmpty {
                        Text("Empty")
                            .foregroundColor(.gray)
                            .padding(10)
                    } else {
                        ScrollView {
                            LazyVStack(alignment: .leading, spacing: 10) {
                                ForEach(Array(filtered.enumerated()), id: \.offset) { item in
                                    Button {
                                        pickerSelection = item.element
                                        showPicker.toggle()
                                    } label: {
                                        VStack(alignment: .leading) {
                                            HStack(spacing: 5) {
                                                Image(systemName: "checkmark")
                                                    .opacity(pickerSelection == item.element ? 1 : 0)
                                                
                                                Text(item.element)
                                                    .foregroundColor(colorScheme == .light ? .black : .white)
                                            }
                                            .padding(.leading, 5)
                                            
                                            if filtered.count > 0 && filtered.last != item.element {
                                                Rectangle()
                                                    .fill(.gray)
                                                    .frame(height: 1)
                                                    .padding(.horizontal)
                                            }
                                        }
                                        .if(item.offset == 0) { $0.padding(.top, 10) }
                                    }
                                }
                            }
                        }
                        .frame(height: calculateHeight(proxy: proxy))
                    }
                }
                .frame(maxWidth: 250)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.thinMaterial)
                        .shadow(color: .black.opacity(0.5), radius: 30)
                )
                .animation(.default, value: filtered)
                .animation(.default, value: focusState)
                .padding(.vertical)
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    func calculateHeight(proxy: GeometryProxy) -> CGFloat {
        let maxHeight: Int = Int(proxy.frame(in: .local).height - 80)
        let height = maxHeight - maxHeight % 40
        return min(CGFloat(filtered.count) * 40, CGFloat(height))
    }
}

struct CustomPicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomPicker(
            pickerSelection: .constant(User.Addresses.getCities().first!),
            showPicker: .constant(true),
            list: User.Addresses.getCities()
        )
    }
}

extension View {
    func customPicker(show: Binding<Bool>, selection: Binding<String>, data: [String]) -> some View {
        return self
            .if(show.wrappedValue) {
                $0.disabled(show.wrappedValue)
                    .blur(radius: 5)
                    .onTapGesture { show.wrappedValue.toggle() }
                    .overlay {
                        CustomPicker(
                            pickerSelection: selection,
                            showPicker: show,
                            list: User.Addresses.getCities()
                        )
                        .transition(.move(edge: .bottom))
                    }
            }
    }
}
