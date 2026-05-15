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
            HStack {
                Spacer()

                HStack(spacing: 12) {
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))

                    Text(title)
                        .font(.custom("MagicSaturday", size: 24))
                }

                Spacer()
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
            .opacity(isPressed ? 0.7 : 1.0)
            .animation(.easeOut(duration: 0.1), value: isPressed)
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
            Color(red: 0.85, green: 0.90, blue: 0.85)
        case .secondary:
            Color.white
        }
    }

    private var borderColor: Color {
        Color.black.opacity(0.15)
    }

    private var foregroundColor: Color {
        Color.black.opacity(0.8)
    }
}
