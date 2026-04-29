//
//  Trivia.swift
//  TriviaGame

// Data model used for decoding API responses.
// Conforms to Codable to allow easy parsing of JSON
// into Swift objects.
//
// Represents the full response structure returned
// by the trivia API (e.g., list of questions).
//
// Does NOT contain any networking or game logic.

import Foundation



struct TriviaResponse: Codable {
    var results: [Trivia]
}
struct Trivia: Identifiable, Codable {
    let id = UUID()
    var type: String
    var difficulty: String
    var category: String
    var question: String
    var correct_answer: String
    var incorrect_answers: [String]
}



