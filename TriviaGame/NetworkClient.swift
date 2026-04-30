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

    func getNowPlaying() async {
        let urlString = "https://opentdb.com/api.php?amount=10&difficulty=easy"
        guard let url = URL(string: urlString) else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(TriviaResponse.self, from: data)

            await MainActor.run {
                self.triviaQuestions = response.results
            }
        } catch {
            print(error)
        }
    }
}
