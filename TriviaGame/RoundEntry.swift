//
//  RoundEntry.swift
//  TriviaGame
//
//  Created by Student on 5/6/26.
//

import Foundation

struct RoundEntry: Codable, Identifiable {
    let id = UUID()
    let username: String
    let score: Int
    let date: Date
}
