import SwiftUI



struct Settings: View {
    @AppStorage("difficultyIndex") private var difficultyIndex: Int = 0
    @AppStorage("categoryID") private var selectedCategoryID: String = "9"
    @AppStorage("username") private var username: String = ""

    @State private var triviaCategories: [String: String] = [
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

                VStack(alignment: .leading, spacing: 16) {
                    Text("Username")
                        .foregroundColor(.white.opacity(0.8))

                    TextField("Enter your username", text: $username)
                        .font(.system(size: 16, weight: .bold))
                        .padding()
                        .background(Color.white.opacity(0.08))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                .padding()
                .background(Color.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
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
                                
                                ForEach(Array(triviaCategories.keys).sorted(), id: \.self) { category in
                                    let categoryID = triviaCategories[category] ?? ""
                                    Button {
                                        selectedCategoryID = categoryID
                                    } label: {
                                        Text(category)
                                            .font(.system(size: 14, weight: .bold))
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 10)
                                            .background(
                                                selectedCategoryID == categoryID
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
        
    }

    
}
