//
//  ProcedureView.swift
//  Online Store
//
//  Created by Олександр Швидкий on 11.01.2023.
//

import SwiftUI
import CachedAsyncImage

struct ProcedureView: View {
    @Environment(\.dismiss) private var dismiss
    let procedure: Procedure
    
    var body: some View {
        NavigationView {
            Form {
                CachedAsyncImage(url: procedure.imageUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } placeholder: {
                    ProgressView().padding()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 10)
                
                Text(procedure.name)
                    .bold()
                
                Text(procedure.formattedDescription)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    WhiteButton(buttonName: "back") { dismiss() }.frame(width: 80)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) { MobButton() }
                ToolbarItem(placement: .principal) { Text(procedure.name).font(.title2.bold()) }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct ProcedureView_Previews: PreviewProvider {
    static var previews: some View {
        ProcedureView(procedure: previewProcedure)
    }
}
