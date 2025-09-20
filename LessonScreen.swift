//
//  LessonScreen.swift
//  Cobra
//
//  Created by Taruna Singh on 3/16/25.
//

import SwiftUI

struct LessonScreen: View {
    @Environment(\.presentationMode) var presentationMode // Allows back navigation
    let lesson: PythonLesson
    @Binding var lessonProgress: [Double]
    @State private var userCode = ""
    @State private var output = "Write your code and press Run!"
    @State private var isLoading = false
    @State private var isCorrect = false

    var body: some View {
        VStack {
            // 🔹 Custom Back Button
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .font(.title2)
                }
                Spacer()
            }
            .padding()

            VStack(alignment: .leading, spacing: 8) {
                Text(lesson.title)
                    .font(.title)
                    .bold()

                Text(lesson.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            .padding()

            HStack(alignment: .top) {
                // 🔹 Line Numbers
                VStack {
                    ForEach(0..<userCode.split(separator: "\n").count, id: \.self) { index in
                        Text("\(index + 1)")
                            .foregroundColor(.gray)
                            .font(.system(.body, design: .monospaced))
                    }
                }
                .padding(.leading, 10)

                // 🔹 Text Editor for Writing Code
                TextEditor(text: $userCode)
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.green)
                    .padding()
                    .frame(height: 150)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray, lineWidth: 1))
                    .padding(5)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }

            // 🔹 Run Code Button
            Button(action: runPythonCode) {
                HStack {
                    if isLoading { ProgressView().padding(.trailing, 5) }
                    Text("Run Code")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(isCorrect ? Color.green : Color.orange)
                .cornerRadius(10)
                .shadow(radius: 5)
            }
            .padding()
            .disabled(isLoading)

            // 🔹 Output Box
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isCorrect ? Color.green.opacity(0.2) : Color.white)
                    .shadow(radius: 5)

                Text(output)
                    .font(.body)
                    .foregroundColor(.black)
                    .padding()
            }
            .frame(height: 80)
            .padding(.horizontal)

            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true) // Hides default back button
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss() // Go back action
        }) {
            Image(systemName: "chevron.left") // Simple back arrow
                .foregroundColor(.white) // Match theme
                .font(.title2)
        })
        .navigationBarBackButtonHidden(true) // Hides default back button
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss() // Go back action
        }) {
            Image(systemName: "chevron.left") // Simple back arrow
                .foregroundColor(.black) // Match theme
                .font(.title2)
        })
 // 🔹 Hide default back button
    }

    // ✅ Fix: This function is now inside the struct
    func runPythonCode() {
        isLoading = true
        output = "Running code..."

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoading = false
            if userCode.trimmingCharacters(in: .whitespacesAndNewlines) == lesson.correctAnswer {
                isCorrect = true
                output = "✅ Correct! Great job!"

                // 🔓 Unlock the next lesson
                if let lessonIndex = lessonProgress.firstIndex(of: lesson.progress), lessonIndex < lessonProgress.count - 1 {
                    withAnimation {
                        lessonProgress[lessonIndex + 1] = 1.0
                    }
                }
            } else {
                isCorrect = false
                output = "❌ Incorrect! Try again!"
            }
        }
    }
}
