//
//  NetworkClient.swift
//  TriviaGame
// Handles all communication with the trivia API.
// Responsible for sending requests, receiving responses,
// and converting them into usable data for the app.
// Does NOT contain any game logic.

import Foundation

@Observable class NetworkClient {
    private(set) var triviaQuestions: [Trivia] = []
    
    private var difficulty: String?
    private var category: String?
    private(set) var triviaResponse: Trivia?
    func getNowPlaying() async {
        triviaQuestions.removeAll()

        let urlString = "https://opentdb.com/api.php?amount=10&difficulty=\(difficulty ?? "easy")&category=\(category ?? "9")"
        let url : URL? = URL(string: urlString)
        guard let urlUnwrapped = url else {
            return
        }
        do {
            let (data,response) = try await URLSession.shared.data(from: urlUnwrapped)
            let triviaResponse: TriviaResponse = try JSONDecoder().decode(TriviaResponse.self, from:data)

            for trivia in triviaResponse.results{
                triviaQuestions.append(trivia)
            }

        }
        catch let error {
            print(error)
        }
    }
    
    func changeDifficulty(to difficultyTo: String) async {
        difficulty = difficultyTo
    }
    func changeCategory(to categoryTo: String) async {
        category = categoryTo
    }
   
}
