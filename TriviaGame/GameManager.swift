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
        }
    }
}
