import SwiftUI

struct Settings: View {

    @AppStorage("difficultyIndex") private var difficultyIndex = 0
    @AppStorage("categoryID") private var selectedCategoryID = "9"
    @AppStorage("username") private var username = ""

    @State private var isLoading = false

    private let difficulties = ["Easy", "Medium", "Hard"]

    private let triviaCategories: [String: String] = [
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

    var body: some View {

        ZStack {

            background

            ScrollView {

                VStack(spacing: 24) {

                    title

                    usernameSection

                    difficultySection

                    categorySection
                }
                .padding(24)
            }
        }
    }

    private var background: some View {
        Color(red: 0.96, green: 0.94, blue: 0.90)
            .ignoresSafeArea()
    }

    private var title: some View {

        VStack(spacing: 4) {

            Text("TRIVIA")
                .font(.custom("MagicSaturday", size: 32))
                .tracking(5)

            Text("Settings")
                .font(.custom("MagicSaturday", size: 54))
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

    private var usernameSection: some View {

        VStack(alignment: .leading, spacing: 14) {

            sectionTitle("Username")

            TextField("Enter username", text: $username)
                .font(.system(size: 16,
                              weight: .semibold,
                              design: .rounded))
                .padding(16)
                .background(Color.white)
                .foregroundColor(Color(red: 0.18, green: 0.18, blue: 0.25))
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
        .cardStyle()
    }

    private var difficultySection: some View {

        VStack(alignment: .leading, spacing: 16) {

            sectionTitle("Difficulty")

            HStack(spacing: 12) {

                ForEach(difficulties.indices, id: \.self) { index in

                    Button {

                        difficultyIndex = index

                    } label: {

                        Text(difficulties[index])
                            .font(.system(size: 15,
                                          weight: .semibold,
                                          design: .rounded))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                difficultyIndex == index
                                ? Color(red: 0.25, green: 0.25, blue: 0.35)
                                : Color.white
                            )
                            .foregroundColor(
                                difficultyIndex == index
                                ? .white
                                : Color(red: 0.20, green: 0.20, blue: 0.30)
                            )
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 16,
                                    style: .continuous
                                )
                            )
                    }
                }
            }
        }
        .cardStyle()
    }

    private var categorySection: some View {

        VStack(alignment: .leading, spacing: 16) {

            sectionTitle("Category")

            if isLoading {

                ProgressView()

            } else {

                ScrollView(.horizontal, showsIndicators: false) {

                    HStack(spacing: 10) {

                        ForEach(Array(triviaCategories.keys).sorted(),
                                id: \.self) { category in

                            let id = triviaCategories[category] ?? ""

                            Button {

                                selectedCategoryID = id

                            } label: {

                                Text(category)
                                    .font(.system(size: 14,
                                                  weight: .semibold,
                                                  design: .rounded))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(
                                        selectedCategoryID == id
                                        ? Color(red: 0.25, green: 0.25, blue: 0.35)
                                        : Color.white
                                    )
                                    .foregroundColor(
                                        selectedCategoryID == id
                                        ? .white
                                        : Color(red: 0.20, green: 0.20, blue: 0.30)
                                    )
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
            }
        }
        .cardStyle()
    }

    private func sectionTitle(_ text: String) -> some View {

        Text(text)
            .font(.system(size: 18,
                          weight: .bold,
                          design: .rounded))
            .foregroundColor(
                Color(red: 0.20, green: 0.20, blue: 0.30)
            )
    }
}

private extension View {

    func cardStyle() -> some View {

        self
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.white.opacity(0.92))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
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
}
