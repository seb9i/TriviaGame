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
    let triviaCategories: [String: String] = [
        "General Knowledge": "9",
        "Entertainment: Books": "10",
        "Entertainment: Film": "11",
        "Entertainment: Music": "12",
        "Entertainment: Musicals & Theatres": "13",
        "Entertainment: Television": "14",
        "Entertainment: Video Games": "15",
        "Entertainment: Board Games": "16",
        "Science & Nature": "17",
        "Science: Computers": "18",
        "Science: Mathematics": "19",
        "Mythology": "20",
        "Sports": "21",
        "Geography": "22",
        "History": "23",
        "Politics": "24",
        "Art": "25",
        "Celebrities": "26",
        "Animals": "27",
        "Vehicles": "28",
        "Entertainment: Comics": "29",
        "Science: Gadgets": "30",
        "Entertainment: Japanese Anime & Manga": "31",
        "Entertainment: Cartoon & Animations": "32"
    ]
    private var difficulty: String?
    private var category: String?
    private(set) var triviaResponse: Trivia?
    func getNowPlaying() async {
        let urlString = "https://opentdb.com/api.php?amount=10&difficulty=\(difficulty ?? "easy")&category=\(triviaCategories[category ?? "General Knowledge"] ?? "9")"
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
