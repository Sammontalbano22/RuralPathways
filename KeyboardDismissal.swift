//
//  KeyboardDismissal.swift
//  CollegePathwaysAI
//
//  Created by sam Montalbano on 11/7/24.
//

// KeyboardDismissal.swift
import SwiftUI

#if canImport(UIKit)
extension View {
    /// Hides the keyboard.
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
