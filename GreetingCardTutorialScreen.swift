import SwiftUI

struct GreetingCardTutorialScreen: View {
    @State private var userCode: String = "print(\"\")"
    @State private var cardGenerated: Bool = false
    @State private var cardCount: Int = 0
    @State private var output: String = ""
    @State private var cardColor: Color = .white

    @State private var fullCobyMessage = ""
    @State private var displayedMessage = ""
    @State private var isTyping = false
    @State private var introStep = 0
    @State private var introMessages: [String] = []

    @State private var showRunBounce = false
    @State private var didRunSuccessfully = false
    @State private var didAutoInsertSpace = false

    @Environment(\.dismiss) var dismiss

    @State private var currentSnippet: String = ""
    @State private var messageID: UUID = UUID()

    static let snippets: [String] = [
        "Congratulations!",
        "Great Job!",
        "You're doing amazing!",
        "Keep going!"
    ]

    var shouldDisableNext: Bool {
        if introStep == 4 {
            return extractPrintedString(from: userCode).lowercased() != normalize(currentSnippet).lowercased()
        } else if introStep == 5 {
            return !didRunSuccessfully
        }
        return false
    }

    var shouldDisableRun: Bool {
        introStep != 5 && introStep < 6
    }

    var editorDisabled: Bool {
        introStep < 4
    }

    var body: some View {
        ZStack {
            Color(red: 250/255, green: 245/255, blue: 235/255).ignoresSafeArea()

            VStack(spacing: 0) {
                // Exit button
                HStack {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                            Text("Exit")
                        }
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(20)
                    }
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)

                // Window bar
                HStack {
                    HStack(spacing: 8) {
                        Circle().fill(Color.red).frame(width: 12, height: 12)
                        Circle().fill(Color.yellow).frame(width: 12, height: 12)
                        Circle().fill(Color.green).frame(width: 12, height: 12)
                    }
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.white)

                // Main layout
                HStack(spacing: 0) {
                    // Card counter
                    VStack(alignment: .leading, spacing: 12) {
                        Text("cards")
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .foregroundColor(Color(red: 255/255, green: 170/255, blue: 100/255))
                            .padding(.top, 16)

                        ForEach(0..<cardCount, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 70, height: 50)
                                .overlay(
                                    Image(systemName: "checkmark.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.green)
                                        .offset(x: 20, y: -20)
                                )
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .frame(width: 110)
                    .background(Color.white)

                    // Editor + Console
                    VStack(spacing: 0) {
                        // File name + Run button
                        HStack {
                            Text("greeting_tool.py")
                                .font(.system(size: 14, weight: .medium, design: .monospaced))
                                .padding(.leading, 12)
                            Spacer()
                            Button(action: runCode) {
                                Text("▶ Run")
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(shouldDisableRun ? Color.gray : Color.orange)
                                    .cornerRadius(6)
                                    .scaleEffect(showRunBounce ? 1.1 : 1.0)
                            }
                            .disabled(shouldDisableRun)
                            .padding(.trailing, 12)
                        }
                        .padding(.vertical, 8)
                        .background(Color(red: 255/255, green: 248/255, blue: 235/255))

                        // TextEditor
                        TextEditor(text: $userCode)
                            .font(.system(size: 15, weight: .medium, design: .monospaced))
                            .foregroundColor(.black)
                            .padding(16)
                            .background(Color(red: 255/255, green: 252/255, blue: 245/255))
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                            .overlay(
                                RoundedRectangle(cornerRadius: 0)
                                    .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                            )
                            .disabled(editorDisabled)

                        HStack {
                            Spacer()
                            if introStep == 4 {
                                Button("Reset") {
                                    userCode = "print(\"\")"
                                }
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Color.orange)
                            }
                        }
                        .padding(.trailing, 16)

                        // Console
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 8) {
                                Image(systemName: "terminal")
                                    .font(.system(size: 14, weight: .bold))
                                Text("Console")
                                    .font(.system(size: 14, weight: .semibold, design: .monospaced))
                            }
                            .foregroundColor(.black)

                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .frame(height: 100)
                                .overlay(
                                    ScrollView {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(output.isEmpty ? "→ Output will appear here..." : output)
                                                .font(.system(size: 14, design: .monospaced))
                                                .foregroundColor(output.contains("SyntaxError") ? .red : .black)
                                        }
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 12)
                                    }
                                )
                        }
                        .padding(12)
                        .background(Color.white)
                    }
                }

                // Bottom Assistant area
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .center, spacing: 10) {
                        Image("CobyIcon")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.orange, lineWidth: 2))
                            .shadow(radius: 3)

                        if cardCount < 3 {
                            VStack(alignment: .leading, spacing: 4) {
                                if introStep < 8 {
                                    Text(displayedMessage)
                                        .font(.custom("Chalkboard SE", size: 15))
                                        .foregroundColor(.black)
                                }

                                if cardCount > 0 {
                                    Text("Task: Complete 3 cards")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.black.opacity(0.9))

                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(Color.white.opacity(0.5))
                                            .frame(height: 8)
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(Color.orange)
                                            .frame(width: CGFloat(cardCount) / 3.0 * 220, height: 8)
                                            .animation(.easeInOut(duration: 0.3), value: cardCount)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                        } else {
                            Button("Send") {
                                cardCount = 0
                                animateMessage("Cards sent! You've earned some coins!")
                                userCode = "print(\"\")"
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }

                    // Navigation buttons
                    if introStep < 8 && cardCount == 0 {
                        HStack {
                            Button(action: {
                                if introStep > 0 {
                                    introStep -= 1
                                    animateMessage(introMessages[introStep])
                                }
                            }) {
                                Text("Back")
                                    .font(.custom("Chalkboard SE", size: 14))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(introStep == 0 ? Color.gray : Color.orange)
                                    .cornerRadius(12)
                            }
                            .disabled(introStep == 0)

                            Spacer()

                            Button(action: {
                                introStep += 1
                                if introStep < introMessages.count {
                                    if introStep == 4 {
                                        currentSnippet = GreetingCardTutorialScreen.snippets[0]
                                        userCode = "print(\"\")"
                                    }
                                    animateMessage(introMessages[introStep])
                                }
                            }) {
                                Text("Next")
                                    .font(.custom("Chalkboard SE", size: 14))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(shouldDisableNext ? Color.gray : Color.orange)
                                    .cornerRadius(12)
                            }
                            .disabled(shouldDisableNext)
                        }
                    }
                }
                .padding(8)
                .background(Color(red: 1.0, green: 0.85, blue: 0.6))
                .cornerRadius(15)
                .shadow(color: Color.orange.opacity(0.2), radius: 4, x: 0, y: 2)
                .padding(.horizontal)
                .padding(.bottom, 12)
            }
        }
        .onAppear {
            showIntroMessages()
        }
    }

    func runCode() {
        let userMessage = normalize(extractPrintedString(from: userCode))
        let expectedMessage = normalize(currentSnippet)

        if userMessage == expectedMessage {
            output = expectedMessage
            if cardCount < 3 {
                cardCount += 1
            }
            didRunSuccessfully = true

            animateMessage("Awesome! That card looks great! Make 3 cards in total, then hit Send to earn some coins.")

            currentSnippet = GreetingCardTutorialScreen.snippets[cardCount % GreetingCardTutorialScreen.snippets.count]
            userCode = "print(\"\")"
        } else {
            output = "SyntaxError: Unexpected token"
            didRunSuccessfully = false
        }
        showRunBounce = false
    }

    func extractPrintedString(from code: String) -> String {
        let pattern = #"print\(\s*"([^"]*)"\s*\)"#
        if let regex = try? NSRegularExpression(pattern: pattern),
           let match = regex.firstMatch(in: code, range: NSRange(code.startIndex..., in: code)),
           let range = Range(match.range(at: 1), in: code) {
            return normalize(String(code[range]))
        }
        return ""
    }

    func showIntroMessages() {
        introMessages = [
            "Hey there! I’m Coby, your CobraOS assistant!",
            "I’ll walk you through using the Greeting Card tool.",
            "In Python, print() is used to display messages on the screen.",
            "We’ll use print() to put a message on your greeting cards.",
            "Type this message inside print(): \"Congratulations!\"",
            "Great job! Now hit the Run button and wait for the magic!",
            "Now it's your turn — try three cards on your own!",
            "Great! Now press Run to see your message appear!"
        ]
        animateMessage(introMessages[0])
    }

    func animateMessage(_ message: String) {
        fullCobyMessage = message
        displayedMessage = ""
        isTyping = true
        let currentID = UUID()
        messageID = currentID

        for (index, letter) in message.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                if messageID == currentID {
                    displayedMessage.append(letter)
                    if index == message.count - 1 {
                        isTyping = false
                    }
                }
            }
        }
    }

    func normalize(_ code: String) -> String {
        code.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "“", with: "\"")
            .replacingOccurrences(of: "”", with: "\"")
            .replacingOccurrences(of: "‘", with: "'")
            .replacingOccurrences(of: "’", with: "'")
            .replacingOccurrences(of: "\u{200B}", with: "")
            .replacingOccurrences(of: "\\", with: "")
    }
}

struct GreetingCardTutorialScreen_Previews: PreviewProvider {
    static var previews: some View {
        GreetingCardTutorialScreen()
    }
}
