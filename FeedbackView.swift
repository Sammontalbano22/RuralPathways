// FeedbackView.swift
import SwiftUI
import PDFKit
import UIKit
import CoreText

struct FeedbackView: View {
    let feedback: String
    var onDismiss: () -> Void

    // State variable to present the share sheet
    @State private var isShareSheetPresented = false
    @State private var pdfData: Data?

    var body: some View {
        NavigationView {
            ScrollView {
                Text(feedback)
                    .padding()
            }
            .navigationTitle("Feedback")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Done Button
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        onDismiss()
                    }
                }
                // Save as PDF Button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: saveAsPDF) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
            // Present the share sheet when pdfData is available
            .sheet(isPresented: $isShareSheetPresented) {
                if let pdfData = pdfData {
                    ShareSheet(activityItems: [pdfData])
                }
            }
        }
    }

    func saveAsPDF() {
        // Generate PDF data from the feedback text
        if let data = generatePDFData() {
            pdfData = data
            isShareSheetPresented = true
        }
    }

    func generatePDFData() -> Data? {
        // Create a PDF document
        let pdfMetaData = [
            kCGPDFContextCreator: "CollegePathwaysAI",
            kCGPDFContextAuthor: "Your App Name",
            kCGPDFContextTitle: "Essay Feedback"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageWidth = 8.5 * 72.0 // 8.5 inches * 72 dpi
        let pageHeight = 11 * 72.0  // 11 inches * 72 dpi
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)

        let data = renderer.pdfData { (context) in
            let attributedText = NSAttributedString(string: feedback, attributes: [
                .font: UIFont.systemFont(ofSize: 12),
                .paragraphStyle: {
                    let style = NSMutableParagraphStyle()
                    style.lineSpacing = 5
                    style.alignment = .left
                    return style
                }()
            ])

            let framesetter = CTFramesetterCreateWithAttributedString(attributedText as CFAttributedString)
            var currentRange = CFRange(location: 0, length: 0)
            var done = false
            var currentPage = 0

            repeat {
                context.beginPage()
                currentPage += 1

                // Draw header
                let headerText = "Essay Feedback"
                let headerAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: 16)
                ]
                headerText.draw(at: CGPoint(x: 20, y: 10), withAttributes: headerAttributes)

                // Set text frame
                let textOrigin = CGPoint(x: 20, y: 40)
                let textWidth = pageRect.width - 40
                let textHeight = pageRect.height - 80
                let textRect = CGRect(origin: textOrigin, size: CGSize(width: textWidth, height: textHeight))

                let framePath = CGMutablePath()
                framePath.addRect(textRect)
                let frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, nil)
                CTFrameDraw(frameRef, context.cgContext)

                let visibleRange = CTFrameGetVisibleStringRange(frameRef)
                currentRange.location += visibleRange.length

                if currentRange.location >= attributedText.length {
                    done = true
                }

                // Draw page number
                let pageNumberText = "Page \(currentPage)"
                let pageNumberAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 12)
                ]
                let pageNumberSize = pageNumberText.size(withAttributes: pageNumberAttributes)
                pageNumberText.draw(
                    at: CGPoint(x: (pageRect.width - pageNumberSize.width) / 2, y: pageRect.height - 40),
                    withAttributes: pageNumberAttributes
                )

            } while !done
        }

        return data
    }
}

// ShareSheet struct to present UIActivityViewController
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        // Exclude certain activity types if desired
        // controller.excludedActivityTypes = [.postToFacebook, .postToTwitter]
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

