//
//  ProcedureMiniCard.swift
//  Online Store
//
//  Created by Олександр Швидкий on 12.01.2023.
//

import SwiftUI
import CachedAsyncImage

struct ProcedureMiniCard: View {
    @Binding var selectedProcedure: Procedure?
    let procedure: Procedure
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(procedure.name)
                .font(.body.bold())
            
            CachedAsyncImage(url: procedure.imageUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } placeholder: {
                ProgressView().padding()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            Text(procedure.shortDescription)
            
            Spacer()
            
            BlackButton(buttonName: "Detail") { selectedProcedure = procedure }
        }
        .border(padding: 10)
    }
}

struct ProcedureMiniCard_Previews: PreviewProvider {
    static var previews: some View {
        ProcedureMiniCard(selectedProcedure: .constant(previewProcedure), procedure: previewProcedure)
            .frame(width: 200, height: 450)
    }
}
