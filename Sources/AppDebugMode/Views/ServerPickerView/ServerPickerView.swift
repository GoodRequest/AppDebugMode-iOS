//
//  ServerPickerView.swift
//  
//
//  Created by Matus Klasovity on 26/06/2023.
//

import SwiftUI

struct ServerPickerView: View {

    // MARK: - State

    @ObservedObject private var viewModel = ServerPickerViewModel()
    
    let servers: [ApiServer]

    // MARK: - Body

    var body: some View {
        VStack {
            serverPicker()
            Divider()
            serverInputView()
            Divider()
            configurationParam(apiServer: viewModel.selectedServer)
            Divider()
            saveButton()
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

    func serverPicker() -> some View {
        VStack {
            Text("Select server:")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(Color.blue)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom)
            

            Picker("Please select a server", selection: $viewModel.selectedServer) {
                ForEach(servers, id: \.self) { server in
                    Text(server.name)
                        .id(server)
                }
            }.pickerStyle(.segmented)
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
                       RoundedRectangle(cornerRadius: 8)
                           .stroke(.gray, lineWidth: 1)
                   )

            PrimaryButton(text: "Use Custom URL") {
                viewModel.saveCustomURL()
            }

            Text("NOTE: Add URL in correct fromat, containing domain as well as directory path.")
                .font(.caption)
                .multilineTextAlignment(.leading)
                .foregroundColor(Color.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
    }

    func configurationParam(apiServer: ApiServer?) -> some View {
        VStack(spacing: 4) {
            Text("Currently picked server:")
                .fontWeight(.semibold)
                .foregroundColor(Color.blue)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom)

            Text(apiServer?.name ?? "No server selected").bold()
            Text(apiServer?.url ?? "")
        }
        .font(.subheadline)
        .frame(maxWidth: .infinity)
        .fixedSize(horizontal: false, vertical: true)
        .padding(.vertical, 16)
    }

    func saveButton() -> some View {
        VStack {
            PrimaryButton(text: "Save") {
                viewModel.saveServerSettings()
            }

            Text("App will be terminated in the moment you save the changes due to propper change of picked server.")
                .foregroundColor(.gray)
                .font(.caption)
                .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 16)
    }

}
