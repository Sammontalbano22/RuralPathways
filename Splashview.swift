// SplashView.swift
import SwiftUI

struct SplashView: View {
    // Binding to control when to transition to ContentView
    @Binding var isActive: Bool
    
    // State variables for animations
    @State private var fadeIn = false
    @State private var scaleUp = false
    
    var body: some View {
        ZStack {
            // Gradient Background
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.purple.opacity(0.7)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Logo Image
                Image("AppLogo") // Ensure "AppLogo" is added to Assets.xcassets
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .shadow(radius: 10)
                
           
            }
            
            // App Name with Animations
            Text("CollegePathwaysAI")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .opacity(fadeIn ? 1 : 0)
                .scaleEffect(scaleUp ? 1.0 : 0.8)
                .animation(.easeOut(duration: 1.0), value: fadeIn)
                .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0), value: scaleUp)
        }
        .onAppear {
            // Trigger animations
            withAnimation {
                self.fadeIn = true
                self.scaleUp = true
            }
            
            // Transition to ContentView after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView(isActive: .constant(false))
    }
}

