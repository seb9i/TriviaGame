//
//  MainMenu.swift
//  TriviaGame
// Handles user interaction at the start of the app.
// Presents options like starting a game or exiting,
// and directs the user accordingly.
//
// UI-focused, not responsible for data or logic.

import SwiftUI

struct MainMenu: View {
    @State private var navigateToGame = false
    @State private var pulseTitle = false
    @State private var gameManager = GameManager(network: NetworkClient())
    @State private var navigateToSettings = false
    
    

    var body: some View {
        
        NavigationStack {
            ZStack {
                background
                VStack(spacing: 32) {
                    Spacer()
                    titleSection
                    buttonStack
                    Spacer()
                }
                .padding(.horizontal, 24)
                
            }
            .navigationDestination(isPresented: $navigateToGame) {
                Group {
                    if gameManager.isGameOver {
                        GameOverView(
                            score: gameManager.score,
                            onPlayAgain: {
                                Task {
                                    await gameManager.startGame()
                                }
                            },
                            onMainMenu: {
                                navigateToGame = false
                            }
                        )
                    } else if let question = gameManager.currentQuestion {
                        TriviaQuestion(trivia: question) { correct in
                            gameManager.submitAnswer(correct: correct)
                        }
                    } else {
                        ProgressView("Loading...")
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToSettings) {
                Settings()
            }
        }
    }

    private var background: some View {
        Color(red: 0.96, green: 0.94, blue: 0.90) // paper-like
            .ignoresSafeArea()
    }

    private var titleSection: some View {
        VStack(spacing: 12) {
            

            Text("TRIVIA")
                .font(.custom("MagicSaturday", size: 52))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(red: 0.2, green: 0.2, blue: 0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .tracking(8)
               

            Text("Game")
                .font(.custom("MagicSaturday", size: 72))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(red: 0.2, green: 0.2, blue: 0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .opacity(pulseTitle ? 0.85 : 1.0)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: pulseTitle)
                .onAppear { pulseTitle = true }

            
        }
    }

    private var buttonStack: some View {
        VStack(spacing: 16) {
            MenuButton(
                title: "Start Game",
                icon: "play.fill",
                style: .primary
            ) {
                Task {
                    await gameManager.startGame()
                    navigateToGame = true
                }
            }
            
            MenuButton(
                title: "Settings",
                icon: "gearshape",
                style: .secondary
            ) {
                navigateToSettings = true
            }

            MenuButton(
                title: "How to Play",
                icon: "questionmark.circle",
                style: .secondary
            ) {}

            MenuButton(
                title: "Leaderboard",
                icon: "trophy",
                style: .secondary
            ) {}
        }
    }

    
}

#Preview {
    MainMenu()
}
