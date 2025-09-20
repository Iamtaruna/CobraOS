//
//  MainTabView.swift
//  Cobra
//
//  Created by Taruna Singh on 3/16/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            
            // 🏠 Home (Dashboard)
            NavigationStack {
                HomeScreen()
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            
            
            // 🧠 Challenges
            NavigationStack {
                ChallengesScreen()
            }
            .tabItem {
                Image(systemName: "brain.head.profile")
                Text("Challenges")
            }
            
            // 🏆 Leaderboard
            NavigationStack {
                LeaderboardScreen()
            }
            .tabItem {
                Image(systemName: "chart.bar.fill")
                Text("Leaderboard")
            }
        }
        .accentColor(.orange) // Changes the selected tab's color
    }
}





struct ChallengesScreen: View {
    var body: some View {
        VStack {
            Text("🧠 Solve Challenges Here!").font(.largeTitle)
        }
    }
}

// 🟢 Preview
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}


