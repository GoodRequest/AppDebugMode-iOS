//
//  SwiftUIDocumentPicker.swift
//  
//
//  Created by Matus Klasovity on 21/09/2023.
//

import SwiftUI
import UniformTypeIdentifiers

struct SwiftUIDocumentPicker: UIViewControllerRepresentable {
    
    enum DocumentPickerError: Error {
        
        case noFile
        
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: SwiftUIDocumentPicker
        
        init(_ parent: SwiftUIDocumentPicker) {
            self.parent = parent
        }
        
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else {
                parent.onCompletion(.failure(DocumentPickerError.noFile))
                return
            }
            parent.onCompletion(.success(url))
        }
        
    }
    
    
    let allowedContentTypes: [UTType]
    let onCompletion: (Result<URL, Error>) -> Void
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: allowedContentTypes)
        picker.view.tintColor = UIColor(AppDebugColors.primary)
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
}
    
// MARK: - Extension

extension View {
    
    /// There is a bug with native SwiftUI sheet modifier in iOS 14, so we have to use this workaround.
    /// https://stackoverflow.com/questions/69613669/swiftui-fileimporter-cannot-show-again-after-dismissing-by-swipe-down
    @available(iOS, deprecated: 15.0, message: "Use SwiftUI's native sheet modifier")
    func swiftUIDocumentPicker(
        isPresented: Binding<Bool>,
        allowedContentTypes: [UTType],
        onCompletion: @escaping (Result<URL, Error>) -> Void
    ) -> some View {
        sheet(isPresented: isPresented) {
            SwiftUIDocumentPicker(allowedContentTypes: allowedContentTypes, onCompletion: onCompletion)
        }
    }
        
}
