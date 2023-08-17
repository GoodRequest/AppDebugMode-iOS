//
//  ReloadCacheDataView.swift
//  
//
//  Created by Matus Klasovity on 31/07/2023.
//

import SwiftUI

struct ReloadCacheDataView: View {
    
    var body: some View {
        VStack {
            PrimaryButton(text: "Reload cache data") {
                CacheProvider.shared.reload()
            }
            
            Text("Reload data from the cache.")
                .font(.caption)
                .multilineTextAlignment(.leading)
                .foregroundColor(Color.gray)
        }
    }

}
