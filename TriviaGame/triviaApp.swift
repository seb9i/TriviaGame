//
//  triviaApp.swift
//  TriviaGame
//
//  Created by Student on 4/29/26.
//



import SwiftUI

@main
struct movieApp: App {
    @State private var networkClient = NetworkClient()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(networkClient)
        }
    }
}
