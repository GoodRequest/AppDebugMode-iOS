//
//  File.swift
//  
//
//  Created by Matus Klasovity on 31/01/2024.
//

import SwiftUI

struct ConsoleLogDetailView: View {

    @Binding var editedString: String
    @Binding var showDetail: Bool

    @State private var isShowingCopiedAlert = false

    var body: some View {
        NavigationView {
            Group {
                if #available(iOS 16, *) {
                    TextEditor(text: $editedString)
                        .font(Font(UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)))
                        .background(AppDebugColors.backgroundSecondary)
                        .scrollContentBackground(.hidden)
                } else {
                    TextEditor(text: $editedString)
                        .font(Font(UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)))
                }
            }
            .foregroundColor(AppDebugColors.textPrimary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        withAnimation {
                            self.showDetail = false
                        }
                    }, label: {
                        Image(systemName: "xmark")
                    })
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        UIPasteboard.general.setValue(editedString, forPasteboardType: "public.plain-text")
                        isShowingCopiedAlert = true
                    }, label: {
                        Text("Copy")
                    })
                }
            }
        }
        .copiedAlert(isPresented: $isShowingCopiedAlert)
        .accentColor(AppDebugColors.primary)
    }

}
