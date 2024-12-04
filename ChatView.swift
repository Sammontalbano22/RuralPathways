import SwiftUI

struct ChatView: View {
    @State private var messages: [Message] = []
    @State private var inputText: String = ""
    @State private var hasPresentedIntroduction = false

    private let applicationPlatforms = """
    **Common Application (Common App):** Accepted by over 1,000 colleges and universities worldwide, the Common App allows students to apply to multiple institutions with a single application. [Visit Common App](https://www.commonapp.org)

    **Coalition Application:** Offered by the Coalition for College, this platform is used by over 150 member institutions and emphasizes access and affordability. [Visit Coalition for College](https://www.coalitionforcollegeaccess.org/)

    **Universal College Application (UCA):** A less commonly used platform, the UCA is accepted by a limited number of institutions. [Visit UCA](https://www.universalcollegeapp.com/)

    **Common Black College Application (CBCA):** This application allows students to apply to multiple Historically Black Colleges and Universities (HBCUs) simultaneously. [Visit CBCA](https://commonblackcollegeapp.com/)

    Additionally, please note that some colleges have their own individual applications.
    """

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                if #available(iOS 17.0, *) {
                    ScrollView {
                        ForEach(messages) { message in
                            ChatBubble(message: message)
                                .padding(.horizontal)
                                .padding(.vertical, 2)
                                .id(message.id)
                        }
                    }
                    .onChange(of: messages.count) {
                        if let lastMessage = messages.last {
                            withAnimation {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                } else {
                    // Fallback on earlier versions
                }
            }
 
            HStack {
                TextField("Type a message...", text: $inputText, onCommit: sendMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .autocapitalization(.sentences)
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .rotationEffect(.degrees(45))
                        .padding()
                }
                .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
        }
        .navigationTitle("Chat")
        .onAppear(perform: addIntroductionAndDisclaimer)
    }

    func addIntroductionAndDisclaimer() {
        guard !hasPresentedIntroduction else { return }
        
        let introduction = Message(isUser: false, content: "Hello! I am a virtual College Readiness Counselor. I am here to help you on your way to applying for college.")
        let disclaimer = Message(isUser: false, content: "Please take my advice with a grain of salt as I am an AI chatbot, not a live counselor. We cannot be held liable for any actions you take based on the advice given.")
        
        messages.append(introduction)
        messages.append(disclaimer)
        
        hasPresentedIntroduction = true
    }
    
    func sendMessage() {
        let trimmedInput = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedInput.isEmpty else { return }
        
        let userMessage = Message(isUser: true, content: trimmedInput)
        messages.append(userMessage)
        inputText = ""
        
        hideKeyboard()
        
        getAIResponse(for: trimmedInput)
    }

    func getAIResponse(for messageContent: String) {
        let lowercasedMessage = messageContent.lowercased()
        
        if lowercasedMessage.contains("get college applications") || lowercasedMessage.contains("apply to colleges") {
            let aiMessage = Message(isUser: false, content: applicationPlatforms)
            messages.append(aiMessage)
        }  else {
            let openAIService = OpenAIService()
            var conversation = messages
            conversation.insert(Message(isUser: false, content: "You are a helpful college preparation counselor for high school students. You are always positive and encouraging. You Divert any questions not related to Academic, College Pursit, or personal help back towards what a high school coucelor should talk about. You do not answer unrelated topics. A large portion of people you talk to are students at rural schools who do not have access to private tutors, AP/IB classes, or a lot of resoruces.Your goal is to highlight the skills rural students have and use the skills to prep students to get into good colleges. "), at: 0)
            
            openAIService.sendMessage(messages: conversation) { response in
                DispatchQueue.main.async {
                    if let response = response {
                        let aiMessage = Message(isUser: false, content: response.trimmingCharacters(in: .whitespacesAndNewlines))
                        messages.append(aiMessage)
                    } else {
                        let errorMessage = Message(isUser: false, content: "Sorry, I couldn't get a response at this time.")
                        messages.append(errorMessage)
                    }
                }
            }
        }
    }
    
    
        
    

    func fetchCollegeDetails(for collegeName: String, specificInfo: String?) {
        NetworkManager.shared.fetchColleges(searchQuery: collegeName, stateFilter: nil) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let colleges):
                    print("Fetched \(colleges.count) college(s) from API for \(collegeName)")
                    if let college = colleges.first(where: { $0.name.lowercased().contains(collegeName.lowercased()) }) {
                        let responseMessage = formatCollegeDetails(college, specificInfo: specificInfo)
                        let aiMessage = Message(isUser: false, content: responseMessage)
                        messages.append(aiMessage)
                    } else {
                        let aiMessage = Message(isUser: false, content: "Sorry, I couldn't find information on \(collegeName). Please check the name or try a different one.")
                        messages.append(aiMessage)
                    }
                case .failure(let error):
                    print("Error fetching college data: \(error.localizedDescription)")
                    let aiMessage = Message(isUser: false, content: "Sorry, I couldn't retrieve college data at this time.")
                    messages.append(aiMessage)
                }
            }
        }
    }
    func formatCollegeDetails(_ college: CollegeData, specificInfo: String?) -> String {
        var response = "**\(college.name)**\n"
        
        switch specificInfo {
        case "student size":
            if let studentSize = college.studentSize {
                response += "Student Population: \(studentSize)"
            } else {
                response += "Student population data is not available."
            }
        case "acceptance rate":
            if let admissionRate = college.admissionRate {
                response += "Admission Rate: \(String(format: "%.2f%%", admissionRate * 100))"
            } else {
                response += "Admission rate data is not available."
            }
        default:
            if let city = college.city, let state = college.state {
                response += "Location: \(city), \(state) \(college.zip ?? "")\n"
            }
            if let admissionRate = college.admissionRate {
                response += "Admission Rate: \(String(format: "%.2f%%", admissionRate * 100))\n"
            }
            if let satAverage = college.satAverage {
                response += "Average SAT Score: \(satAverage)\n"
            }
            if let studentSize = college.studentSize {
                response += "Student Population: \(studentSize)\n"
            }
            if let url = college.url {
                response += "[Visit College Website](https://\(url))"
            }
        }
        
        return response
    }
    
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}

