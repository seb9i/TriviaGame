//
//  NetworkClient.swift
//  TriviaGame
// Handles all communication with the trivia API.
// Responsible for sending requests, receiving responses,
// and converting them into usable data for the app.
// Does NOT contain any game logic.

import Foundation
@Observable
class NetworkClient{
    private(set) var triviaQuestions: [Trivia] = []
    
    private(set) var triviaResponse: Trivia?
    func getNowPlaying() async {
        let urlString = "https://opentdb.com/api.php?amount=10&difficulty=easy"
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
    
   
}
