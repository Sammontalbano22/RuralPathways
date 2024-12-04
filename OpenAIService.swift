// OpenAIService.swift
import Foundation

class OpenAIService {
    private let apiKey: String
    private let baseURL = "https://api.openai.com/v1/chat/completions"

    init() {
        // Load API key from Config struct
        self.apiKey = Config.openAIAPIKey
    }

    /// Sends a message to OpenAI's Chat Completion API with optional context.
    /// - Parameters:
    ///   - messages: An array of `Message` structs representing the conversation.
    ///   - context: Optional additional context to include in the prompt.
    ///   - completion: Completion handler with the assistant's response or `nil` if failed.
    func sendMessage(messages: [Message], context: String? = nil, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: baseURL) else {
            print("Invalid URL.")
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Convert `Message` structs to API-compatible format
        var apiMessages = messages.map { ["role": $0.isUser ? "user" : "assistant", "content": $0.content] }

        // If context is provided, add it as a system message
        if let context = context {
            let systemMessage: [String: String] = ["role": "system", "content": context]
            apiMessages.insert(systemMessage, at: 0)
        }

        let json: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": apiMessages,
            "max_tokens": 600,
            "temperature": 0.7
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error serializing JSON: \(error)")
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle network error
            if let error = error {
                print("Error calling OpenAI API: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            // Validate data
            guard let data = data else {
                print("No data received from OpenAI API.")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            // Decode the response
            do {
                let decoder = JSONDecoder()
                let apiResponse = try decoder.decode(OpenAIAPIResponse.self, from: data)

                // Extract the assistant's message
                if let firstChoice = apiResponse.choices.first {
                    let content = firstChoice.message.content.trimmingCharacters(in: .whitespacesAndNewlines)
                    DispatchQueue.main.async {
                        completion(content)
                    }
                } else {
                    print("No choices found in API response.")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            } catch {
                print("Error decoding response from OpenAI API: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        task.resume()
    }

    /// Sends an essay to OpenAI's API for grading and feedback.
    /// - Parameters:
    ///   - prompt: The essay prompt including the user's essay.
    ///   - completion: Completion handler with the feedback or `nil` if failed.
    func sendEssayGradingPrompt(prompt: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: baseURL) else {
            print("Invalid URL.")
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // System prompt to define the assistant's role
        let systemPrompt = """
        You are a college admissions expert with years of experience.  Assess the essay for clarity, coherence, originality, and adherence to prompt. Provide actionable steps to make better. Only if an essay if far off from meeting one of these assessable characteristic, suggest more dramatic, but respectful, essay improvements and give an example essay.
 """

        let json: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "system", "content": systemPrompt],
                ["role": "user", "content": prompt]
            ],
            "max_tokens": 1000,
            "temperature": 0.7
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error serializing JSON: \(error)")
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle network error
            if let error = error {
                print("Error calling OpenAI API: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            // Validate data
            guard let data = data else {
                print("No data received from OpenAI API.")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            // Decode the response
            do {
                let decoder = JSONDecoder()
                let apiResponse = try decoder.decode(OpenAIAPIResponse.self, from: data)

                // Extract the assistant's message
                if let firstChoice = apiResponse.choices.first {
                    let content = firstChoice.message.content.trimmingCharacters(in: .whitespacesAndNewlines)
                    DispatchQueue.main.async {
                        completion(content)
                    }
                } else {
                    print("No choices found in API response.")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            } catch {
                print("Error decoding response from OpenAI API: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        task.resume()
    }
}

