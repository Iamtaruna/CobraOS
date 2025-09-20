//
//  OnBoardingScreen.swift
//  Cobra
//
//  Created by Taruna Singh on 3/16/25.
//

import SwiftUI

struct OnboardingScreen: View {
    @State private var currentPage = 0
    @State private var navigateToHome = false

    let onboardingData = [
        ("Welcome!", "This app helps you learn Python step by step."),
        ("Daily Challenges", "Complete tasks to improve your coding skills."),
        ("Leaderboard", "Compete with others and climb the ranks!"),
        ("Get Started", "Let's begin your journey!")
    ]

    var body: some View {
        NavigationStack {
            VStack {
                TabView(selection: $currentPage) {
                    ForEach(0..<onboardingData.count, id: \.self) { index in
                        VStack {
                            Text(onboardingData[index].0)
                                .font(.title)
                                .padding()

                            Text(onboardingData[index].1)
                                .multilineTextAlignment(.center)
                                .padding()

                            if index == onboardingData.count - 1 {
                                Button("Finish") {
                                    completeOnboarding()
                                }
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))

                // ✅ New NavigationLink for HomeScreen
                NavigationLink(value: navigateToHome ? "Home" : nil) {
                    EmptyView()
                }
            }
            .navigationDestination(for: String.self) { value in
                if value == "Home" {
                    HomeScreen()
                }
            }
        }
    }

    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        navigateToHome = true
    }
}
