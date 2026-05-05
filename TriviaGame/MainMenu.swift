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
                VStack {
                    Spacer()
                    titleSection
                    Spacer()
                    buttonStack
                    Spacer(minLength: 60)
                    footerNote
                }
                .padding(.horizontal, 32)
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
        LinearGradient(
            colors: [
                Color(red: 0.06, green: 0.06, blue: 0.14),
                Color(red: 0.10, green: 0.04, blue: 0.22)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    private var titleSection: some View {
        VStack(spacing: 12) {
            

            Text("TRIVIA")
                .font(.system(size: 52, weight: .black, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, Color(red: 0.76, green: 0.60, blue: 1.0)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .tracking(8)
            Text("Game")
                .font(.system(size: 72, weight: .black, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, Color(red: 0.76, green: 0.60, blue: 1.0)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .scaleEffect(pulseTitle ? 1.08 : 1.0)
                .animation(
                    .easeInOut(duration: 1.4).repeatForever(autoreverses: true),
                    value: pulseTitle
                )
                .onAppear { pulseTitle = true }

            Text("Open Trivia DB")
                .font(.system(size: 13, weight: .medium, design: .monospaced))
                .foregroundColor(.white.opacity(0.35))
                .padding(.top, 4)
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

    private var footerNote: some View {
        Text("Questions sourced from opentdb.com")
            .font(.system(size: 11, design: .monospaced))
            .foregroundColor(.white.opacity(0.20))
    }
}

#Preview {
    MainMenu()
}
