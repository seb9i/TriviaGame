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

    var body: some View {
        NavigationStack {
            ZStack {
                background
                VStack(spacing: 0) {
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
                Text("Game View")
                    .navigationTitle("Trivia")
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
                navigateToGame = true
            }

            MenuButton(
                title: "How to Play",
                icon: "questionmark.circle",
                style: .secondary
            ) {
                // add instructions sheet
            }

            MenuButton(
                title: "Leaderboard",
                icon: "trophy",
                style: .secondary
            ) {
                // add show leaderboard
            }
        }
    }

    private var footerNote: some View {
        Text("Questions sourced from opentdb.com")
            .font(.system(size: 11, design: .monospaced))
            .foregroundColor(.white.opacity(0.20))
    }
}

private enum MenuButtonStyle { case primary, secondary }

private struct MenuButton: View {
    let title: String
    let icon: String
    let style: MenuButtonStyle
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                Text(title)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .opacity(0.5)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 18)
            .background(buttonBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(borderColor, lineWidth: 1)
            )
            .foregroundColor(foregroundColor)
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: isPressed)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded   { _ in isPressed = false }
        )
    }

    @ViewBuilder
    private var buttonBackground: some View {
        switch style {
        case .primary:
            LinearGradient(
                colors: [Color(red: 0.55, green: 0.35, blue: 1.0),
                         Color(red: 0.35, green: 0.20, blue: 0.85)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        case .secondary:
            Color.white.opacity(0.07)
        }
    }

    private var borderColor: Color {
        style == .primary
            ? Color.purple.opacity(0.6)
            : Color.white.opacity(0.12)
    }

    private var foregroundColor: Color {
        style == .primary ? .white : .white.opacity(0.80)
    }
}

#Preview {
    MainMenu()
}
