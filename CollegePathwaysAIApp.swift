// CollegePathwaysAIApp.swift
import SwiftUI

@main
struct CollegePathwaysAIApp: App {
    // State variable to control the active view
    @State private var isActive: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isActive {
                ContentView()
            } else {
                SplashView(isActive: $isActive)
            }
        }
    }
}

