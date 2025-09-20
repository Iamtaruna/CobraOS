//
//  LeaderboardScreen.swift
//  Cobra
//
//  Created by Taruna Singh on 3/16/25.
//

import SwiftUI

struct LeaderboardScreen: View {
    var body: some View {
        VStack {
            Text("🏆 Leaderboard")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Text("Coming Soon!")
                .font(.title2)
                .foregroundColor(.gray)
        }
    }
}

struct LeaderboardScreen_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardScreen()
    }
}
