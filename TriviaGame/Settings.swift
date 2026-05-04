import SwiftUI

struct CategoryResponse: Decodable {
    let trivia_categories: [TriviaCategory]
}

struct TriviaCategory: Identifiable, Decodable {
    let id: Int
    let name: String
}

struct Settings: View {
    @AppStorage("difficultyIndex") private var difficultyIndex: Int = 0
    @AppStorage("categoryID") private var selectedCategoryID: Int = 9

    @State private var categories: [TriviaCategory] = []
    @State private var isLoading = false

    private let difficulties = ["Easy", "Medium", "Hard"]

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.06, green: 0.06, blue: 0.14),
                    Color(red: 0.10, green: 0.04, blue: 0.22)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 40) {
                Text("Settings")
                    .font(.system(size: 42, weight: .black, design: .rounded))
                    .foregroundColor(.white)

                VStack(spacing: 20) {
                    Text("Difficulty")
                        .foregroundColor(.white.opacity(0.8))

                    HStack(spacing: 12) {
                        ForEach(difficulties.indices, id: \.self) { index in
                            Button {
                                difficultyIndex = index
                            } label: {
                                Text(difficulties[index])
                                    .font(.system(size: 16, weight: .bold))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        difficultyIndex == index
                                        ? Color.purple
                                        : Color.white.opacity(0.08)
                                    )
                                    .foregroundColor(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                }
                .padding()
                .background(Color.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 16))

                VStack(alignment: .leading, spacing: 16) {
                    Text("Category")
                        .foregroundColor(.white.opacity(0.8))

                    if isLoading {
                        ProgressView()
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(categories) { category in
                                    Button {
                                        selectedCategoryID = category.id
                                    } label: {
                                        Text(category.name)
                                            .font(.system(size: 14, weight: .bold))
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 10)
                                            .background(
                                                selectedCategoryID == category.id
                                                ? Color.purple
                                                : Color.white.opacity(0.08)
                                            )
                                            .foregroundColor(.white)
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(Color.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 16))

                Spacer()
            }
            .padding(24)
        }
        .task {
            await loadCategories()
        }
    }

    func loadCategories() async {
        guard categories.isEmpty else { return }
        guard let url = URL(string: "https://opentdb.com/api_category.php") else { return }

        do {
            isLoading = true
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(CategoryResponse.self, from: data)
            categories = decoded.trivia_categories
            isLoading = false
        } catch {
            print("Failed to load categories:", error)
            isLoading = false

            categories = [
                .init(id: 9, name: "General Knowledge"),
                .init(id: 21, name: "Sports"),
                .init(id: 23, name: "History"),
                .init(id: 17, name: "Science"),
                .init(id: 18, name: "Computers")
            ]
        }
    }
}
