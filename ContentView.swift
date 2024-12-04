// ContentView.swift
import SwiftUI

struct ContentView: View {
    @State private var animateChat = false
    @State private var animateScholarship = false
    @State private var animateCollege = false
    @State private var animateEssay = false // New state variable for animation

    var body: some View {
        NavigationView {
            ZStack {
                // Background Gradient
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Spacer()

                    // App Logo or Welcome Message
                    VStack(spacing: 20) {
                        Image("AppLogo") // Replace with your logo image name
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.white)
                            .shadow(radius: 10)

                        Text("CollegePathwaysAI")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                    }

                    Spacer()

                    // Button Area
                    HStack(spacing: 30) {
                        // Chat with Counselor Button
                        NavigationLink(destination: ChatView()) {
                            VStack {
                                Image(systemName: "message.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .clipShape(Circle())
                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                                    .scaleEffect(animateChat ? 1.1 : 1.0)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.5), value: animateChat)

                                Text("Chat")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                        }
                        .onTapGesture {
                            animateChat = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                animateChat = false
                            }
                        }

                        // Scholarship Search Button
                        NavigationLink(destination: ScholarshipLinkView()) {
                            VStack {
                                Image(systemName: "graduationcap.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.green)
                                    .clipShape(Circle())
                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                                    .scaleEffect(animateScholarship ? 1.1 : 1.0)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.5), value: animateScholarship)

                                Text("Scholarships")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                        }
                        .onTapGesture {
                            animateScholarship = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                animateScholarship = false
                            }
                        }

                        // Find College Button
                        NavigationLink(destination: CollegeListView()) {
                            VStack {
                                Image(systemName: "building.columns.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.orange)
                                    .clipShape(Circle())
                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                                    .scaleEffect(animateCollege ? 1.1 : 1.0)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.5), value: animateCollege)

                                Text("Find College")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                        }
                        .onTapGesture {
                            animateCollege = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                animateCollege = false
                            }
                        }

                        // Essay Grader Button
                        NavigationLink(destination: EssayEditorView()) {
                            VStack {
                                Image(systemName: "pencil.and.outline")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.pink)
                                    .clipShape(Circle())
                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                                    .scaleEffect(animateEssay ? 1.1 : 1.0)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.5), value: animateEssay)

                                Text("Essay Grader")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                        }
                        .onTapGesture {
                            animateEssay = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                animateEssay = false
                            }
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationBarHidden(true)
        }
    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}

