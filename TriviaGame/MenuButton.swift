//
//  MenuButton.swift
//  TriviaGame
//
//  Created by Student on 5/5/26.
//

import SwiftUI

enum MenuButtonStyle { case primary, secondary }

struct MenuButton: View {
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
                .onEnded { _ in isPressed = false }
        )
    }

    private var buttonBackground: some View {
        switch style {
        case .primary:
            LinearGradient(
                colors: [
                    Color(red: 0.55, green: 0.35, blue: 1.0),
                    Color(red: 0.35, green: 0.20, blue: 0.85)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .secondary:
            LinearGradient(
                        colors: [
                            Color.white.opacity(0.07),
                            Color.white.opacity(0.07)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
            )
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
