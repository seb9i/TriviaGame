import SwiftUI

struct GameOverView: View {
    let score: Int
    let onPlayAgain: () -> Void
    let onMainMenu: () -> Void

    var body: some View {
        ZStack {
            background

            VStack {
                Spacer()

                titleSection

                Spacer()

                scoreSection

                Spacer()

                buttonStack

                Spacer(minLength: 60)
            }
            .padding(.horizontal, 32)
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
            Text("GAME")
                .font(.system(size: 52, weight: .black, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, Color(red: 0.76, green: 0.60, blue: 1.0)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .tracking(8)

            Text("OVER")
                .font(.system(size: 72, weight: .black, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, Color(red: 0.76, green: 0.60, blue: 1.0)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
    }

    private var scoreSection: some View {
        VStack(spacing: 8) {
            Text("Your Score")
                .font(.system(size: 14, design: .monospaced))
                .foregroundColor(.white.opacity(0.4))

            Text("\(score)")
                .font(.system(size: 48, weight: .black, design: .rounded))
                .foregroundColor(.white)
        }
    }

    private var buttonStack: some View {
        VStack(spacing: 16) {
            MenuButton(
                title: "Play Again",
                icon: "arrow.clockwise",
                style: .primary,
                action: onPlayAgain
            )

            MenuButton(
                title: "Main Menu",
                icon: "house",
                style: .secondary,
                action: onMainMenu
            )
        }
    }
}
