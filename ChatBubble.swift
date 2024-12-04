// ChatBubble.swift
import SwiftUI

struct ChatBubble: View {
    let message: Message

    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
                Text(message.content)
                    .padding()
                    .background(userBubbleColor)
                    .foregroundColor(userTextColor)
                    .cornerRadius(15)
                    .frame(maxWidth: 250, alignment: .trailing)
            } else {
                Text(message.content)
                    .padding()
                    .background(assistantBubbleColor)
                    .foregroundColor(assistantTextColor)
                    .cornerRadius(15)
                    .frame(maxWidth: 250, alignment: .leading)
                Spacer()
            }
        }
        .padding(.vertical, 2)
    }
    
    // MARK: - Adaptive Colors
    
    // User Message Colors
    private var userBubbleColor: Color {
        Color.blue
    }
    
    private var userTextColor: Color {
        Color.white
    }
    
    // Assistant Message Colors
    private var assistantBubbleColor: Color {
        Color(UIColor.systemGray5)
    }
    
    private var assistantTextColor: Color {
        Color.primary
    }
}

struct ChatBubble_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview for User Message in Light Mode
            ChatBubble(message: Message(isUser: true, content: "Hello! How can I assist you today?"))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
            
            // Preview for Assistant Message in Light Mode
            ChatBubble(message: Message(isUser: false, content: "Sure, I can help you with that."))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
            
            // Preview for User Message in Dark Mode
            ChatBubble(message: Message(isUser: true, content: "Hello! How can I assist you today?"))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
            
            // Preview for Assistant Message in Dark Mode
            ChatBubble(message: Message(isUser: false, content: "Sure, I can help you with that."))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}

