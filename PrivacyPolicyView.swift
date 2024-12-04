import SwiftUI

struct PrivacyPolicyView: View {
    @State private var acceptedPolicy = false
    
    var body: some View {
        VStack {
            ScrollView {
                Text("Privacy Policy")
                    .font(.headline)
                    .padding()
                Text("""
                Your data will be securely stored and used only to enhance your experience. By signing up, you agree to our terms of service and privacy policy.
                """)
                    .padding()
            }
            .frame(maxHeight: 400)
            
            Toggle(isOn: $acceptedPolicy) {
                Text("I have read and accept the Privacy Policy")
            }
            .padding()
            
            Button("Continue to Signup") {
                // Navigate to SignupView
            }
            .disabled(!acceptedPolicy)
            .padding()
        }
        .padding()
    }
}

