//
//  TriviaQuestion.swift
//  TriviaGame
//
//  Styled to match the Main Menu aesthetic.
//

import SwiftUI

struct TriviaQuestion: View {

    var trivia: Trivia
    var onAnswer: (Bool) -> Void

    @State private var shuffledAnswers: [String] = []
    @State private var selectedAnswer: String? = nil
    @State private var revealed = false

    var body: some View {
        ZStack {
            background
            VStack(spacing: 0) {
                Spacer()
                titleSection
                Spacer(minLength: 24)
                metaSection
                Spacer(minLength: 28)
                questionCard
                Spacer(minLength: 36)
                answerGrid
                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .onAppear {
            buildAnswers()
        }
        .onChange(of: trivia.question) {
            selectedAnswer = nil
            revealed = false
            buildAnswers()
        }
    }

    private var background: some View {
        Color(red: 0.96, green: 0.94, blue: 0.90)
            .ignoresSafeArea()
    }


    private var titleSection: some View {
        VStack(spacing: 6) {
            Text("TRIVIA")
                .font(.custom("MagicSaturday", size: 34))
                .tracking(5)

            Text("Question")
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

    private var metaSection: some View {

        HStack(spacing: 12) {

            MetaPill(text: trivia.category)

            MetaPill(text: trivia.difficulty.capitalized)
        }
    }

    private var questionCard: some View {

        VStack {

            Text(trivia.question.htmlDecoded)
                .font(.system(size: 24,
                              weight: .semibold,
                              design: .rounded))
                .foregroundColor(
                    Color(red: 0.18, green: 0.18, blue: 0.25)
                )
                .multilineTextAlignment(.center)
                .lineSpacing(5)
                .padding(28)
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white.opacity(0.95))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(
                            Color.black.opacity(0.08),
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

    private var answerGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ],
            spacing: 16
        ) {
            ForEach(shuffledAnswers, id: \.self) { answer in
                AnswerButton(
                    text: answer.htmlDecoded,
                    state: buttonState(for: answer),
                    revealed: revealed
                ) {
                    guard !revealed else { return }
                    selectedAnswer = answer
                    revealed = true
                    let correct = (answer == trivia.correct_answer)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        onAnswer(correct)
                    }
                }
            }
        }
    }

    private func buildAnswers() {
        shuffledAnswers =
        (trivia.incorrect_answers + [trivia.correct_answer]).shuffled()
    }

    private func buttonState(for answer: String) -> AnswerButton.ButtonState {
        guard revealed,
              let selected = selectedAnswer
        else {
            return .idle
        }
        if answer == trivia.correct_answer {
            return .correct
        }
        if answer == selected {
            return .wrong
        }
        return .idle
    }
}

private struct MetaPill: View {
    let text: String
    var body: some View {

        Text(text)
            .font(.system(size: 13,
                          weight: .semibold,
                          design: .rounded))
            .foregroundColor(
                Color(red: 0.20, green: 0.20, blue: 0.30)
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(Color.white.opacity(0.9))
                    .overlay(
                        Capsule()
                            .stroke(
                                Color.black.opacity(0.08),
                                lineWidth: 1
                            )
                    )
            )
    }
}

private struct AnswerButton: View {
    enum ButtonState {
        case idle
        case correct
        case wrong
    }
    let text: String
    let state: ButtonState
    let revealed: Bool
    let action: () -> Void
    @State private var isPressed = false
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 16,weight: .medium, design: .rounded))
                .foregroundColor(labelColor)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .padding(.horizontal, 14)
                .padding(.vertical, 18)
                .frame(maxWidth: .infinity,
                       minHeight: 100)
                .background(fillColor)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 20,
                        style: .continuous
                    )
                )
                .overlay(
                    RoundedRectangle(
                        cornerRadius: 20,
                        style: .continuous
                    )
                    .stroke(borderColor, lineWidth: 1)
                )
                .shadow(
                    color: shadowColor,
                    radius: 10,
                    x: 0,
                    y: 6
                )
                .scaleEffect(isPressed ? 0.96 : 1.0)
                .animation(
                    .easeOut(duration: 0.12),
                    value: isPressed
                )
        }
        .buttonStyle(.plain)
        .disabled(revealed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    isPressed = true
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
    }

    private var fillColor: Color {
        switch state {
        case .idle:
            return Color.white
        case .correct:
            return Color.green.opacity(0.18)
        case .wrong:
            return Color.red.opacity(0.15)
        }
    }
    private var borderColor: Color {
        switch state {
        case .idle:
            return Color.black.opacity(0.08)
        case .correct:
            return Color.green.opacity(0.45)
        case .wrong:
            return Color.red.opacity(0.4)
        }
    }
    private var labelColor: Color {
        switch state {
        case .idle:
            return Color(red: 0.18, green: 0.18, blue: 0.25)
        case .correct:
            return Color.green.opacity(0.9)
        case .wrong:
            return Color.red.opacity(0.9)
        }
    }

    private var shadowColor: Color {
        switch state {
        case .idle:
            return .black.opacity(0.06)
        case .correct:
            return .green.opacity(0.15)

        case .wrong:
            return .red.opacity(0.12)
        }
    }
}

extension String {
    var htmlDecoded: String {
        var decoded = self
        let entities: [String: String] = [
            "&quot;": "\"",
            "&amp;": "&",
            "&apos;": "'",
            "&lt;": "<",
            "&gt;": ">",
            "&#039;": "'"
        ]
        for (entity, replacement) in entities {
            decoded = decoded.replacingOccurrences(
                of: entity,
                with: replacement
            )
        }
        return decoded
    }
}
