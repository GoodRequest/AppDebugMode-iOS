//
//  CacheValueListItemView.swift
//  
//
//  Created by Matus Klasovity on 20/09/2023.
//

import SwiftUI

struct CacheValueListItemView: View {
    
    // MARK: - Properties
    
    let key: String
    let value: String
    @Binding var isShowingCopiedAlert: Bool

    // MARK: - Body
    
    var body: some View {
        Button {
            UIPasteboard.general.string = value
            withAnimation {
                isShowingCopiedAlert = true
            }
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    Text(key)
                        .bold()
                        .foregroundColor(AppDebugColors.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Image(systemName: "doc.on.doc")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(AppDebugColors.primary)
                        .frame(width: 20, height: 20)
                }
                
                Text(value)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
            }
        }
        .buttonStyle(.borderless)
    }
    
}
