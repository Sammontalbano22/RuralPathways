//
//  OpenAIAPIResponse.swift
//  CollegePathwaysAI
//
//  Created by sam Montalbano on 11/7/24.
//

// OpenAIAPIResponse.swift
import Foundation

struct OpenAIAPIResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let choices: [Choice]
    let usage: Usage
}

struct Choice: Codable {
    let index: Int
    let message: MessageResponse
    let finish_reason: String?
}

struct MessageResponse: Codable {
    let role: String
    let content: String
}

struct Usage: Codable {
    let prompt_tokens: Int
    let completion_tokens: Int
    let total_tokens: Int
}
