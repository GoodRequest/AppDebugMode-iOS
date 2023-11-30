//
//  ServerPickerView.swift
//  
//
//  Created by Matus Klasovity on 26/06/2023.
//

import SwiftUI
import SwiftUIIntrospect

struct ServerPickerView: View {

    // MARK: - State

    @ObservedObject var viewModel: ApiServerCollection

    // MARK: - Body

    var body: some View {
        VStack {
            currentlyPickedServerView(apiServer: viewModel.selectedServer)
            serverPicker()
            serverInputView()
        }
        .onChange(of: viewModel.selectedServer) { _ in
            hideKeyboard()
            viewModel.hasValidationError = false
        }
        .alert(isPresented: $viewModel.hasValidationError) {
            Alert(
                title: Text("Validation error"),
                message: Text("Please check url format")
            )
        }
    }

}

// MARK: - Components

private extension ServerPickerView {
    
    func currentlyPickedServerView(apiServer: ApiServer?) -> some View {
        VStack(spacing: 4) {
            Text("Currently picked server:")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(AppDebugColors.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom)

            Text(apiServer?.name ?? "No server selected")
                .bold()
                .foregroundColor(AppDebugColors.primary)

            Text(apiServer?.url ?? "")
                .foregroundColor(AppDebugColors.textPrimary)
            
        }
        .font(.subheadline)
        .frame(maxWidth: .infinity)
        .fixedSize(horizontal: false, vertical: true)
        .padding(.vertical, 16)
    }

    func serverPicker() -> some View {
        VStack {
            Text("Select server:")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(AppDebugColors.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom)
            

            Picker("Please select a server", selection: $viewModel.selectedServer) {
                ForEach(viewModel.servers, id: \.self) { server in
                    Text(server.name)
                        .id(server)
                }
            }
            .pickerStyle(.segmented)
            .introspect(.picker(style: .segmented), on: .iOS(.v14, .v15, .v16, .v17)) { segmentedControl in
                segmentedControl.selectedSegmentTintColor = UIColor(AppDebugColors.primary)
                segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
                segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor(AppDebugColors.primary)], for: .normal)
            }
        }
        .padding(.vertical, 16)
    }

    func serverInputView() -> some View {
        VStack {
            TextField("", text: $viewModel.textContent)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .keyboardType(.URL)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8).stroke(AppDebugColors.textSecondary, lineWidth: 1)
                )
                .foregroundColor(AppDebugColors.textPrimary)

            ButtonFilled(text: "Use Custom URL", style: .secondary) {
                viewModel.useCustomURL()
            }

            Text("NOTE: Add URL in correct fromat, containing domain as well as directory path.")
                .font(.caption)
                .multilineTextAlignment(.leading)
                .foregroundColor(AppDebugColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
    }

}
