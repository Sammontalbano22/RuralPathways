// DocumentPicker.swift
import SwiftUI
import UniformTypeIdentifiers
import UIKit
import PDFKit

struct DocumentPicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIDocumentPickerViewController

    var completion: (Result<String, Error>) -> Void

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let supportedTypes: [UTType] = [
            .plainText,
            .utf8PlainText,
            .rtf,
            .pdf
        ]
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(completion: completion)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var completion: (Result<String, Error>) -> Void

        init(completion: @escaping (Result<String, Error>) -> Void) {
            self.completion = completion
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else {
                completion(.failure(NSError(domain: "No file selected", code: -1, userInfo: nil)))
                return
            }

            // Start accessing the security-scoped resource
            guard url.startAccessingSecurityScopedResource() else {
                completion(.failure(NSError(domain: "Can't access file", code: -1, userInfo: nil)))
                return
            }

            defer { url.stopAccessingSecurityScopedResource() }

            do {
                let text = try extractText(from: url)
                completion(.success(text))
            } catch {
                completion(.failure(error))
            }
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            completion(.failure(NSError(domain: "User cancelled", code: -1, userInfo: nil)))
        }

        // Helper method to extract text from different file types
        private func extractText(from url: URL) throws -> String {
            let fileExtension = url.pathExtension.lowercased()

            switch fileExtension {
            case "txt":
                return try String(contentsOf: url, encoding: .utf8)
            case "rtf":
                let attributedString = try NSAttributedString(url: url, options: [:], documentAttributes: nil)
                return attributedString.string
            case "pdf":
                return try extractTextFromPDF(url: url)
            default:
                throw NSError(domain: "Unsupported file type", code: -1, userInfo: nil)
            }
        }

        private func extractTextFromPDF(url: URL) throws -> String {
            guard let pdfDocument = PDFDocument(url: url) else {
                throw NSError(domain: "Unable to open PDF", code: -1, userInfo: nil)
            }

            var text = ""
            let pageCount = pdfDocument.pageCount

            for pageIndex in 0..<pageCount {
                guard let page = pdfDocument.page(at: pageIndex) else { continue }
                if let pageContent = page.string {
                    text += pageContent + "\n"
                }
            }

            return text
        }
    }
}

