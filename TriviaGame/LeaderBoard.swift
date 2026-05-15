import SwiftUI

struct LeaderboardView: View {

    @State private var entries: [RoundEntry] = []

    var body: some View {

        ZStack {

            background

            VStack(spacing: 24) {

                titleSection

                if entries.isEmpty {

                    emptyState

                } else {

                    leaderboardList
                }

                Spacer()
            }
            .padding(24)
        }
        .onAppear {
            loadData()
        }
    }

    private var background: some View {
        Color(red: 0.96, green: 0.94, blue: 0.90)
            .ignoresSafeArea()
    }

    private var titleSection: some View {

        VStack(spacing: 4) {

            Text("TRIVIA")
                .font(.custom("MagicSaturday", size: 32))
                .tracking(5)

            Text("Leaderboard")
                .font(.custom("MagicSaturday", size: 52))
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

    private var emptyState: some View {

        VStack(spacing: 10) {

            Image(systemName: "trophy")
                .font(.system(size: 42))
                .foregroundColor(
                    Color(red: 0.35, green: 0.35, blue: 0.45)
                )

            Text("No scores yet")
                .font(.system(size: 18,
                              weight: .semibold,
                              design: .rounded))
                .foregroundColor(
                    Color(red: 0.35, green: 0.35, blue: 0.45)
                )
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 50)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color.white.opacity(0.94))
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(
                            Color.black.opacity(0.06),
                            lineWidth: 1
                        )
                )
        )
        .shadow(
            color: .black.opacity(0.06),
            radius: 10,
            x: 0,
            y: 6
        )
    }

    private var leaderboardList: some View {

        ScrollView {

            VStack(spacing: 14) {

                ForEach(entries.indices, id: \.self) { index in

                    let entry = entries[index]

                    HStack(spacing: 16) {

                        ZStack {

                            Circle()
                                .fill(
                                    Color(
                                        red: 0.20,
                                        green: 0.20,
                                        blue: 0.30
                                    )
                                )
                                .frame(width: 42, height: 42)

                            Text("\(index + 1)")
                                .font(.system(size: 16,
                                              weight: .bold,
                                              design: .rounded))
                                .foregroundColor(.white)
                        }

                        VStack(alignment: .leading, spacing: 4) {

                            Text(entry.username)
                                .font(.system(size: 18,
                                              weight: .bold,
                                              design: .rounded))
                                .foregroundColor(
                                    Color(
                                        red: 0.18,
                                        green: 0.18,
                                        blue: 0.25
                                    )
                                )

                            Text(entry.date, style: .date)
                                .font(.system(size: 13,
                                              weight: .medium,
                                              design: .rounded))
                                .foregroundColor(
                                    Color(
                                        red: 0.45,
                                        green: 0.45,
                                        blue: 0.55
                                    )
                                )
                        }

                        Spacer()

                        Text("\(entry.score)")
                            .font(.system(size: 28,
                                          weight: .black,
                                          design: .rounded))
                            .foregroundColor(
                                Color(
                                    red: 0.20,
                                    green: 0.20,
                                    blue: 0.30
                                )
                            )
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 24,
                            style: .continuous
                        )
                        .fill(Color.white.opacity(0.94))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(
                                    Color.black.opacity(0.06),
                                    lineWidth: 1
                                )
                        )
                    )
                    .shadow(
                        color: .black.opacity(0.05),
                        radius: 8,
                        x: 0,
                        y: 5
                    )
                }
            }
        }
    }

    private func loadData() {

        if let data = UserDefaults.standard.data(forKey: "leaderboard"),
           let decoded = try? JSONDecoder().decode([RoundEntry].self, from: data) {

            entries = decoded
        }
    }
}
