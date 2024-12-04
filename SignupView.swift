//import SwiftUI
//
//struct SignupView: View {
//    @State private var email = ""
//    @State private var username = ""
//    @State private var password = ""
//    @State private var age = ""
//    @State private var highSchool = ""
//    @State private var grade = ""
//    @State private var showAlert = false
//    @State private var alertMessage = ""
//
//    var body: some View {
//        Form {
//            TextField("Email", text: $email)
//                .keyboardType(.emailAddress)
//                .autocapitalization(.none)
//            TextField("Username", text: $username)
//            SecureField("Password", text: $password)
//            TextField("Age", text: $age)
//                .keyboardType(.numberPad)
//            TextField("High School", text: $highSchool)
//            TextField("Grade", text: $grade)
//            
//            Button("Sign Up") {
//                guard let userAge = Int(age) else {
//                    alertMessage = "Please enter a valid age."
//                    showAlert = true
//                    return
//                }
//                
//                let newUser = User(email: email, username: username, age: userAge, highSchool: highSchool, grade: grade)
//                DatabaseManager.shared.createUserAccount(email: email, password: password, user: newUser) { success in
//                    if success {
//                        alertMessage = "Account created successfully!"
//                    } else {
//                        alertMessage = "Failed to create account."
//                    }
//                    showAlert = true
//                }
//            }
//            .alert(isPresented: $showAlert) {
//                Alert(title: Text("Signup Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//            }
//        }
//    }
//}
////
////  SignupView.swift
////  CollegePathwaysAI
////
////  Created by sam Montalbano on 11/15/24.
////
//
