//
//  GameManager.swift
//  TriviaGame
// Manages the flow of the trivia game.
// Uses TriviaQuestion objects to present questions,
// track score, and validate answers.
//
// Contains the core game logic.

import Foundation

@Observable
class GameManager {
    
    private let network: NetworkClient
    private(set) var score: Int = 0
    private(set) var currentIndex: Int = 0
    private(set) var isGameOver: Bool = false
    
    var difficultyIndex: Int {
        UserDefaults.standard.integer(forKey: "difficultyIndex")
    }

    var categoryId: String {
        UserDefaults.standard.string(forKey: "categoryID") ?? "9"
    }
    
    var username: String {
        let name = UserDefaults.standard.string(forKey: "username") ?? ""
        return name.isEmpty ? "Anonymous" : name
    }
    
    var currentQuestion: Trivia? {
        guard currentIndex < network.triviaQuestions.count else { return nil }
        return network.triviaQuestions[currentIndex]
    }
    
    init(network: NetworkClient) {
        self.network = network
    }
    
    func startGame() async {
        score = 0
        currentIndex = 0
        isGameOver = false

        let difficultyText: String
        switch difficultyIndex {
        case 0: difficultyText = "easy"
        case 1: difficultyText = "medium"
        case 2: difficultyText = "hard"
        default: difficultyText = "easy"
        }

        await network.changeDifficulty(to: difficultyText)
        await network.changeCategory(to: categoryId)
        await network.getNowPlaying()
    }
    
    func submitAnswer(correct: Bool) {
        if correct {
            score += 1
        }
        nextQuestion()
    }
    
    private func nextQuestion() {
        if currentIndex < network.triviaQuestions.count - 1 {
            currentIndex += 1
        } else {
            isGameOver = true
            saveScore()
        }
    }
    
    func saveScore() {
        let newEntry = RoundEntry(
            username: username,
            score: score,
            date: Date()
        )
        
        var entries = loadLeaderboard()
        entries.append(newEntry)
        
        entries.sort { $0.score > $1.score }
        
        entries = Array(entries.prefix(20))
        
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: "leaderboard")
        }
    }
    
    func loadLeaderboard() -> [RoundEntry] {
        guard let data = UserDefaults.standard.data(forKey: "leaderboard"),
              let entries = try? JSONDecoder().decode([RoundEntry].self, from: data)
        else {
            return []
        }
        return entries
    }
}
