import SwiftUI

struct Settings: View {
    @AppStorage("difficultyIndex") private var difficultyIndex: Double = 0

    private var difficultyText: String {
        switch Int(difficultyIndex) {
        case 0: return "Easy"
        case 1: return "Medium"
        case 2: return "Hard"
        default: return "Easy"
        }
    }

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
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))

                    Text(difficultyText)
                        .font(.title2.bold())
                        .foregroundColor(.white)

                    Slider(value: $difficultyIndex, in: 0...2, step: 1)
                        .tint(.purple)
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
