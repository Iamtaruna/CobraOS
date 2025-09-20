//
//  SignUpScreen.swift
//  Cobra
//
//  Created by Taruna Singh on 3/16/25.
//

import SwiftUI

struct SignUpScreen: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isRegistered = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()

                // 🐍 Sign-Up Title
                Text("Slither In")
                    .font(.system(size: 48, weight: .semibold))
                    .foregroundColor(.black)

                Text("Let's create an account!")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                // 📝 Editable Input Fields
                VStack(spacing: 15) {
                    CustomTextField(placeholder: "Enter your name", text: $name)
                    CustomTextField(placeholder: "Enter your email", text: $email)
                    CustomSecureField(placeholder: "Create a password", text: $password)
                }
                .padding(.horizontal, 20)

                // 🛠 Register Button
                Button(action: {
                    registerUser()
                }) {
                    Text("Register")
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity) // Full-width button
                        .background(Color(hex: "#FFB347"))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.horizontal, 20)

                // 🔹 Social Media Sign-In
                VStack(spacing: 15) {
                    SocialSignUpButton(
                        icon: "google_icon",
                        text: "Sign Up with Google",
                        backgroundColor: .white,
                        textColor: .black,
                        borderColor: .gray
                    ) {
                        signInWithGoogle()
                    }

                    SocialSignUpButton(
                        icon: "applelogo",
                        text: "Sign Up with Apple",
                        backgroundColor: .black,
                        textColor: .white,
                        borderColor: .black
                    ) {
                        signInWithApple()
                    }

                    SocialSignUpButton(
                        icon: "facebook_icon",
                        text: "Sign Up with Facebook",
                        backgroundColor: Color.blue,
                        textColor: .white,
                        borderColor: .blue
                    ) {
                        signInWithFacebook()
                    }
                }
                .padding(.top, 20)

                Spacer()
            }
            .navigationDestination(isPresented: $isRegistered) { // ✅ Fixes navigation
                HomeScreen()
            }
            .padding(.top, 50)
        }
    }

    func registerUser() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UserDefaults.standard.set(false, forKey: "hasCompletedOnboarding")
            isRegistered = true // ✅ Triggers navigation
        }
    }

    // 🛠 Google Sign-In Logic
    func signInWithGoogle() {
        print("🟢 Google Sign-In Clicked!")
        // Add Firebase Google Auth Logic Here
    }

    // 🍏 Apple Sign-In Logic
    func signInWithApple() {
        print("🔵 Apple Sign-In Clicked!")
        // Add Firebase Apple Auth Logic Here
    }

    // 🔵 Facebook Sign-In Logic
    func signInWithFacebook() {
        print("🔵 Facebook Sign-In Clicked!")
        // Add Firebase Facebook Auth Logic Here
    }
}

// 🛠 Custom Input Fields (Restores Previous Look)
struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String

    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 3)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .padding(.bottom, 10)
    }
}

// 🛠 Custom SecureField (For Password Input)
struct CustomSecureField: View {
    let placeholder: String
    @Binding var text: String

    var body: some View {
        SecureField(placeholder, text: $text)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 3)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .padding(.bottom, 10)
    }
}


// 🛠 Custom Social Sign-Up Button Component
struct SocialSignUpButton: View {
    var icon: String
    var text: String
    var backgroundColor: Color
    var textColor: Color
    var borderColor: Color
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                if icon == "applelogo" {
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(textColor)
                } else {
                    Image(icon) // Uses image from Assets.xcassets
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: 24, height: 24)
                        .clipShape(Circle()) // Ensures it's circular
                }

                Text(text)
                    .fontWeight(.bold)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .cornerRadius(10)
            .shadow(radius: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor, lineWidth: 1)
            )
        }
        .padding(.horizontal, 20)
    }
}

