//
//  HomeScreen.swift
//  Cobra
//
//  Created by Taruna Singh on 3/16/25.
//

import SwiftUI
struct HomeScreen: View {
    @StateObject private var tutorialVM = TutorialOneViewModel()
    @State private var currentLessonIndex: Int = 0
    @State private var livesRemaining = 5
    @State private var showTutorialHighlight = true
    @State private var showArrowBounce = false
    @State private var fadeEffect = false
    @State private var navigateToLesson = false // Tracks navigation state

    let lessons = [
        PythonLesson(title: "Introduction to Python", description: "Let's get started with coding!", progress: 1.0, icon: "play.circle", correctAnswer: "print('Hello, World!')")
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                LinearGradient(
                    gradient: Gradient(colors: [Color.orange.opacity(0.4), Color.yellow.opacity(0.2)]),
                    startPoint: .top,
                    endPoint: .bottom
                ).ignoresSafeArea()

                // Dimming Effect
                if showTutorialHighlight {
                    Color.black.opacity(0.25)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showTutorialHighlight = false
                        }
                }

                VStack(spacing: 20) {
                    HStack {
                        Text("T U T O R I A L")
                            .font(.custom("Feather Bold", size: 18))
                            .foregroundColor(Color.white)

                        Spacer()

                        // ❤️ Heart-Based Streak System
                        HStack(spacing: 6) {
                            ForEach(0..<5) { index in
                                Image(systemName: index < livesRemaining ? "heart.fill" : "heart")
                                    .foregroundColor(index < livesRemaining ? .red : .gray)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.orange)
                                .shadow(color: Color.orange.opacity(0.5), radius: 5)
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                    Spacer()

                    // Cozy Desk Illustration
                    Image("hello_world_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 420)
                        .padding(.horizontal, 20)
                        .cornerRadius(20)
                        .shadow(color: Color.orange.opacity(0.5), radius: 10)

                    // Tutorial Guide Text
                    if showTutorialHighlight {
                        Text("Tap here to begin your Python journey!")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.bottom, 10)
                            .opacity(fadeEffect ? 1 : 0.3)
                            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: fadeEffect)
                    }

                    // Circular Lesson Buttons
                    HStack(spacing: 8) {
                        ForEach(1...5, id: \.self) { number in
                            if number == 1 {
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 1)) {
                                        navigateToLesson = true
                                    }
                                }) {
                                    ZStack {
                                        // Animated Arrow
                                        if showTutorialHighlight {
                                            Image(systemName: "arrow.down")
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundColor(.orange)
                                                .offset(y: showArrowBounce ? -15 : -25)
                                                .opacity(0.8)
                                                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: showArrowBounce)
                                        }

                                        Text("1")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .frame(width: 65, height: 65)
                                            .background(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [Color.orange, Color.yellow]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .clipShape(Circle())
                                            .shadow(color: Color.orange.opacity(0.9), radius: 12, x: 0, y: 5)
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.white.opacity(0.8), lineWidth: 2)
                                                    .shadow(color: Color.orange.opacity(0.7), radius: 8)
                                            )
                                            .opacity(fadeEffect ? 1 : 0.3)
                                            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: fadeEffect)
                                    }
                                    .onAppear {
                                        showArrowBounce = true
                                        fadeEffect = true
                                    }
                                }
                            } else {
                                ZStack {
                                    Circle()
                                        .fill(Color.gray.opacity(0.5))
                                        .frame(width: 50, height: 50)

                                    Image(systemName: "lock.fill")
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    .padding(.top, 20)

                    NavigationLink(
                        destination: Tutorial_one(viewModel: tutorialVM),
                        isActive: $navigateToLesson
                    ) {
                        EmptyView()
                    }



                    .opacity(navigateToLesson ? 1 : 0)
                    .animation(.easeInOut(duration: 1), value: navigateToLesson)


                    Spacer()

                    VStack {
                        HStack {
                            TabButton(icon: "chart.bar.fill", destination: DashboardScreen(), isActive: false)
                            Spacer()
                            TabButton(icon: "house.fill", destination: HomeScreen(), isActive: true)
                            Spacer()
                            TabButton(icon: "person.crop.circle", destination: UserProfileScreen(), isActive: false)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .shadow(radius: 10)
                        )
                        .padding(.horizontal, 20)
                    }
                }
                .padding()
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: EmptyView())
        }
    }
}

// Tab Button Component
struct TabButton<Destination: View>: View {
    let icon: String
    let destination: Destination
    var isActive: Bool

    var body: some View {
        NavigationLink(destination: destination) {
            VStack {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(isActive ? .yellow : Color.gray)
                    .padding(10)
                    .background(isActive ? Color.orange : Color.clear)
                    .clipShape(Circle())
                    .shadow(radius: isActive ? 3 : 0)
            }
            .padding()
            .background(isActive ? Color.white : Color.clear)
            .cornerRadius(20)
            .fixedSize()
        }
        .buttonStyle(PlainButtonStyle())
    }
}
