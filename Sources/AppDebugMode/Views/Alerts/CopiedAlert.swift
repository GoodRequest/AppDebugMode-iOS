//
//  CopiedAlert.swift
//  
//
//  Created by Matus Klasovity on 21/09/2023.
//

import SwiftUI

struct CopiedAlert: View {
    
    // MARK: - Private

    @State private var count = 1
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Binding var isPresented: Bool
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .center) {
            AppDebugColors.backgroundPrimary.opacity(0.3).edgesIgnoringSafeArea(.all)

            VStack(alignment: .center, spacing: 24) {
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                    .foregroundColor(AppDebugColors.primary)

                Text("Copied")
                    .font(.title2)
                    .foregroundColor(AppDebugColors.primary)
                    .multilineTextAlignment(.center)
            }
            .padding(16)
            .frame(width: 250)
            .background(AppDebugColors.backgroundSecondary)
            .cornerRadius(24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Glass().edgesIgnoringSafeArea(.all))
        .onTapGesture {
            withAnimation {
                isPresented = false
            }
        }
        .onReceive(timer) { _ in
            count -= 1
            if count <= 0 {
                withAnimation {
                    isPresented = false
                }
            }
        }
        .ignoresSafeArea()
    }
    
}

// MARK: - Extension

extension View {
    
    func copiedAlert(isPresented: Binding<Bool>) -> some View {
        ZStack {
            self
            ZStack {
                if isPresented.wrappedValue {
                    CopiedAlert(isPresented: isPresented)
                        .transition(.opacity)
                }
            }
        }
    }
    
}
