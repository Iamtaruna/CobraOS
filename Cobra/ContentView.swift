//
//  ContentView.swift
//  Cobra
//
//  Created by Taruna Singh on 3/16/25.
//

import SwiftUI

struct ContentView: View {
    @State private var opacity: Double = 0
    @State private var showSignUpScreen = false // Controls transition
    @State private var snakeOffset: CGFloat = 0

    var body: some View {
        NavigationView {
            ZStack {
                // 🔹 Transition Screen (Fades Out)
                if !showSignUpScreen {
                    VStack {
                        Image("snake_open") // Replace with your actual snake image name
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .opacity(opacity)
                            .offset(x: snakeOffset)
                            .onAppear {
                                // 🔸 Fade-in effect
                                withAnimation(.easeIn(duration: 1.5)) {
                                    opacity = 1
                                }

                                // 🔸 Snake peeking side-to-side
                                withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                                    snakeOffset = 20 // Adjust for peek distance
                                }

                                // 🔸 Trigger fade-out & transition after delay
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    withAnimation(.easeOut(duration: 1.5)) { // Fades out before switch
                                        opacity = 0
                                    }

                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { // Waits for fade
                                        withAnimation(.easeIn(duration: 1.5)) {
                                            showSignUpScreen = true
                                        }
                                    }
                                }
                            }

                        Text("C O B R A")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.orange)
                            .kerning(5)
                            .opacity(opacity)
                    }
                }

                // 🔹 Sign-Up Screen (Fades In)
                if showSignUpScreen {
                    SignUpScreen()
                        .transition(.opacity) // Smooth fade-in transition
                }
            }
            .background(Color.white)
            .edgesIgnoringSafeArea(.all)
        }
        .navigationViewStyle(.stack)

    }
}

// 🛠 Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

