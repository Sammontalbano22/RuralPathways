// EssayEditorView.swift
import SwiftUI
import UniformTypeIdentifiers
import UIKit
import PDFKit

struct EssayEditorView: View {
    @State private var essayText: String = ""
    @State private var isLoading: Bool = false
    @State private var feedback: String?
    @State private var showAlert: Bool = false
    @FocusState private var isTextFieldFocused: Bool

    // State variables for document picker and error handling
    @State private var isDocumentPickerPresented = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @State private var showFeedbackView = false // New state variable

    var body: some View {
        VStack {
            // Import Essay Button
            Button(action: {
                isDocumentPickerPresented = true
            }) {
                HStack {
                    Image(systemName: "doc.fill")
                    Text("Import Essay")
                        .bold()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.secondary)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding([.horizontal, .bottom])

            // Supported file types info
            Text("Supported file types: .txt, .rtf, .pdf")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.bottom, 5)

            // Text Editor for essay input
            TextEditor(text: $essayText)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
                .frame(height: 300)
                .focused($isTextFieldFocused)

            // Get Feedback Button
            Button(action: gradeEssay) {
                HStack {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Get Feedback")
                            .bold()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(essayText.isEmpty ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled(essayText.isEmpty || isLoading)
            .padding()

            Spacer()
        }
        .padding()
        .navigationTitle("Essay Grader")
        .onTapGesture {
            hideKeyboard()
        }
        .sheet(isPresented: $isDocumentPickerPresented) {
            DocumentPicker { result in
                handleImportResult(result)
            }
        }
        .fullScreenCover(isPresented: $showFeedbackView) {
            if let feedback = feedback {
                FeedbackView(feedback: feedback) {
                    showFeedbackView = false
                }
            }
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Import Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text("Could not get feedback at this time."), dismissButton: .default(Text("OK")))
        }
    }

    // Handle the result from the document picker
    func handleImportResult(_ result: Result<String, Error>) {
        switch result {
        case .success(let text):
            self.essayText = text
        case .failure(let error):
            self.errorMessage = error.localizedDescription
            self.showErrorAlert = true
        }
    }

    // Function to send the essay to OpenAI for grading
    func gradeEssay() {
        isLoading = true
        feedback = nil

        let openAIService = OpenAIService()
        let prompt = """
        You are an expert college admissions counselor. Please provide a detailed critique of the following college application essay. Highlight strengths and weaknesses, and suggest specific improvements.

        Essay:
        \(essayText)
        """

        openAIService.sendEssayGradingPrompt(prompt: prompt) { response in
            isLoading = false
            if let response = response {
                feedback = response
                showFeedbackView = true // Present the feedback view
            } else {
                showAlert = true
            }
        }
    }
}

struct EssayEditorView_Previews: PreviewProvider {
    static var previews: some View {
        EssayEditorView()
    }
}

