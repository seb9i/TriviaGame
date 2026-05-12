//
//  LeaderBoard.swift
//  TriviaGame
//
//  Created by Student on 5/6/26.
//

import SwiftUI

struct LeaderboardView: View {
    @State private var entries: [RoundEntry] = []
    
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
            
            VStack(spacing: 24) {
                Text("Leaderboard")
                    .font(.system(size: 42, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                
                if entries.isEmpty {
                    Text("No scores yet")
                        .foregroundColor(.white.opacity(0.7))
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(entries.indices, id: \.self) { index in
                                let entry = entries[index]
                                
                                HStack {
                                    Text("#\(index + 1)")
                                        .font(.headline)
                                        .foregroundColor(.purple)
                                        .frame(width: 40)
                                    
                                    VStack(alignment: .leading) {
                                        Text(entry.username)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        
                                        Text(entry.date, style: .date)
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.6))
                                    }
                                    
                                    Spacer()
                                    
                                    Text("\(entry.score)")
                                        .font(.title3.bold())
                                        .foregroundColor(.white)
                                }
                                .padding()
                                .background(Color.white.opacity(0.08))
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding(24)
        }
        .onAppear {
            loadData()
        }
    }
    
    private func loadData() {
        if let data = UserDefaults.standard.data(forKey: "leaderboard"),
           let decoded = try? JSONDecoder().decode([RoundEntry].self, from: data) {
            entries = decoded
        }
    }
}
