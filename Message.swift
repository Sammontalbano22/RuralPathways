// Message.swift
import Foundation

struct Message: Identifiable {
    let id = UUID()
    let isUser: Bool
    let content: String
}

