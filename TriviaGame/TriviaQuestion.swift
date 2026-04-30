//
//  TriviaQuestion.swift
//  TriviaGame
//
//  UI screen for displaying a single trivia question.
//  Receives a Trivia model, shows the question and
//  four shuffled answer buttons, and reports the
//  selected answer back via a callback.
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
                metaSection
                Spacer(minLength: 24)
                questionCard
                Spacer(minLength: 32)
                answerGrid
                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .onAppear { buildAnswers() }
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

    private var metaSection: some View {
        HStack(spacing: 10) {
            MetaPill(text: trivia.category)
            MetaPill(text: trivia.difficulty.capitalized)
        }
    }

    private var questionCard: some View {
        Text(trivia.question.htmlDecoded)
            .font(.system(size: 22, weight: .semibold, design: .rounded))
            .foregroundStyle(
                LinearGradient(
                    colors: [.white, Color(red: 0.76, green: 0.60, blue: 1.0)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .multilineTextAlignment(.center)
            .lineSpacing(4)
            .padding(.horizontal, 8)
    }
    
    private var answerGrid: some View {
        LazyVGrid(
            columns: [GridItem(.flexible(), spacing: 14),
                      GridItem(.flexible(), spacing: 14)],
            spacing: 14
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                        onAnswer(correct)
                    }
                }
            }
        }
    }

    private func buildAnswers() {
        shuffledAnswers = (trivia.incorrect_answers + [trivia.correct_answer]).shuffled()
    }

    private func buttonState(for answer: String) -> AnswerButton.ButtonState {
        guard revealed, let selected = selectedAnswer else { return .idle }
        if answer == trivia.correct_answer { return .correct }
        if answer == selected              { return .wrong   }
        return .idle
    }
}

private struct MetaPill: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.system(size: 12, weight: .semibold, design: .rounded))
            .foregroundColor(Color(red: 0.76, green: 0.60, blue: 1.0))
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color.white.opacity(0.08))
                    .overlay(Capsule().stroke(Color(red: 0.76, green: 0.60, blue: 1.0).opacity(0.35), lineWidth: 1))
            )
    }
}

private struct AnswerButton: View {
    enum ButtonState { case idle, correct, wrong }

    let text: String
    let state: ButtonState
    let revealed: Bool
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundColor(labelColor)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .padding(.horizontal, 12)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity, minHeight: 90)
                .background(fillColor)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(borderColor, lineWidth: 1.2)
                )
                .scaleEffect(isPressed ? 0.96 : 1.0)
                .animation(.easeOut(duration: 0.12), value: isPressed)
        }
        .buttonStyle(.plain)
        .disabled(revealed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true  }
                .onEnded   { _ in isPressed = false }
        )
    }

    private var fillColor: Color {
        switch state {
        case .idle:    return Color.white.opacity(0.07)
        case .correct: return Color.green.opacity(0.25)
        case .wrong:   return Color.red.opacity(0.22)
        }
    }

    private var borderColor: Color {
        switch state {
        case .idle:    return Color.white.opacity(0.18)
        case .correct: return Color.green.opacity(0.7)
        case .wrong:   return Color.red.opacity(0.6)
        }
    }

    private var labelColor: Color {
        switch state {
        case .idle:    return .white
        case .correct: return Color(red: 0.45, green: 1.0, blue: 0.65)
        case .wrong:   return Color(red: 1.0, green: 0.45, blue: 0.45)
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
            decoded = decoded.replacingOccurrences(of: entity, with: replacement)
        }

        return decoded
    }
}
