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

                Spacer(minLength: 50)
            }
            .padding(.horizontal, 24)
        }
    }

    private var background: some View {
        Color(red: 0.96, green: 0.94, blue: 0.90)
            .ignoresSafeArea()
    }

    private var titleSection: some View {

        VStack(spacing: 4) {

            Text("GAME")
                .font(.custom("MagicSaturday", size: 40))
                .tracking(6)

            Text("OVER")
                .font(.custom("MagicSaturday", size: 68))
        }
        .foregroundStyle(
            LinearGradient(
                colors: [
                    Color(red: 0.20, green: 0.20, blue: 0.30)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }

    private var scoreSection: some View {

        VStack(spacing: 10) {

            Text("Final Score")
                .font(.system(size: 16,
                              weight: .semibold,
                              design: .rounded))
                .foregroundColor(
                    Color(red: 0.35, green: 0.35, blue: 0.45)
                )

            Text("\(score)")
                .font(.system(size: 72,
                              weight: .black,
                              design: .rounded))
                .foregroundColor(
                    Color(red: 0.18, green: 0.18, blue: 0.25)
                )
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 36)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(Color.white.opacity(0.94))
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(
                            Color.black.opacity(0.06),
                            lineWidth: 1
                        )
                )
        )
        .shadow(
            color: .black.opacity(0.08),
            radius: 12,
            x: 0,
            y: 8
        )
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
