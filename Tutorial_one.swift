//
//  Tutorial_one.swift
//  Cobra
//
//  Created by Taruna Singh on 5/11/25.

// FINAL: TutorialOne with Monty link to new screen

// FINAL: TutorialOne with Monty link to new screen

import SwiftUI

struct ChatMessage: Identifiable {
    let id = UUID()
    var text: String
    let isFromBoss: Bool
}

struct MessageBubble: View {
    let text: String
    let isFromBoss: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if isFromBoss {
                Image("Monty - BOSS")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.orange, lineWidth: 2))
                    .shadow(radius: 3)

                Text(text)
                    .font(.custom("Chalkboard SE", size: 16))
                    .padding(12)
                    .background(Color(red: 1.0, green: 0.75, blue: 0.55))
                    .foregroundColor(.black)
                    .cornerRadius(15)
                    .frame(maxWidth: 250, alignment: .leading)

                Spacer()
            } else {
                Spacer()

                Text(text)
                    .font(.custom("Chalkboard SE", size: 16))
                    .padding(12)
                    .background(Color(red: 0.85, green: 0.92, blue: 1.0))
                    .foregroundColor(.black)
                    .cornerRadius(8)
                    .frame(maxWidth: 250, alignment: .trailing)
            }
        }
        .padding(.horizontal)
    }
}

struct CustomChatInputBar: View {
    var placeholder: String
    @Binding var text: String
    var onSend: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.white)
                    .frame(height: 40)
                    .overlay(
                        Rectangle()
                            .stroke(Color.black, lineWidth: 2)
                    )

                TextField(placeholder, text: $text)
                    .font(.custom("Chalkboard SE", size: 16))
                    .padding(.horizontal, 12)
                    .frame(height: 40)
                    .foregroundColor(.black)
                    .textFieldStyle(PlainTextFieldStyle())
            }
            .cornerRadius(4)
            .frame(maxWidth: .infinity)

            Button(action: onSend) {
                Image("SendButton")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .shadow(radius: 2)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
}

class TutorialOneViewModel: ObservableObject {
    @Published var nameInput: String = ""
    @Published var userInput: String = ""
    @Published var feedback: String = ""
    @Published var step: Int = 0
    @Published var messages: [ChatMessage] = []
    @Published var isTyping: Bool = false
}

struct Tutorial_one: View {
    @AppStorage("playerName") var playerName: String = ""
    @ObservedObject var viewModel: TutorialOneViewModel
    @State private var openCardTool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(viewModel.messages) { message in
                                if message.text == "[Open the card tool]" && message.isFromBoss {
                                    HStack(alignment: .top, spacing: 10) {
                                        Image("Monty - BOSS")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.orange, lineWidth: 2))
                                            .shadow(radius: 3)

                                        Button(action: {
                                            openCardTool = true
                                        }) {
                                            HStack(alignment: .center, spacing: 10) {
                                                Image("Toolimage")
                                                    .resizable()
                                                    .frame(width: 40, height: 40)
                                                    .padding(8)
                                                    .background(Color.white)
                                                    .cornerRadius(10)
                                                    .shadow(radius: 3)

                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text("Greeting Card Tool")
                                                        .font(.custom("Chalkboard SE", size: 16))
                                                        .bold()
                                                        .foregroundColor(.black)
                                                    Text("Tap to begin designing your first card!")
                                                        .font(.custom("Chalkboard SE", size: 14))
                                                        .foregroundColor(.gray)
                                                }
                                            }
                                            .padding()
                                            .background(Color(red: 1.0, green: 0.85, blue: 0.6))
                                            .cornerRadius(15)
                                            .shadow(radius: 2)
                                        }
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                } else {
                                    MessageBubble(text: message.text, isFromBoss: message.isFromBoss)
                                        .id(message.id)
                                }
                            }

                            if viewModel.step == 4, !viewModel.feedback.isEmpty {
                                MessageBubble(text: viewModel.feedback, isFromBoss: true)
                            }
                        }
                        .padding(.top, 20)
                        .onChange(of: viewModel.messages.count) { _ in
                            withAnimation {
                                proxy.scrollTo(viewModel.messages.last?.id, anchor: .bottom)
                            }
                        }
                    }
                }

                CustomChatInputBar(
                    placeholder: viewModel.step == 2 ? "Type your name..." : "",
                    text: Binding(
                        get: { viewModel.step == 2 ? viewModel.nameInput : "" },
                        set: { newValue in
                            if viewModel.step == 2 {
                                viewModel.nameInput = newValue
                            }
                        }
                    ),
                    onSend: {
                        if viewModel.step == 2 && !viewModel.nameInput.trimmingCharacters(in: .whitespaces).isEmpty {
                            playerName = viewModel.nameInput
                            viewModel.messages.append(ChatMessage(text: viewModel.nameInput, isFromBoss: false))
                            viewModel.step += 1
                            addMontyMessages([
                                "Welcome to Cobra, \(playerName)! My name is Monty, I'll be overseeing your assignments.",
                                "I’d love to do a better introduction, but we need the greeting cards done for the upcoming event.",
                                "I'll quickly show you the process.",
                                "[Open the card tool]"
                            ]) {
                                viewModel.step = 4
                            }
                        }
                    }
                )
                .disabled(viewModel.step != 2)
                .opacity(viewModel.step == 2 ? 1.0 : 0.5)
                .padding(.bottom, 10)


                NavigationLink(destination: CardTutorialScreen(), isActive: $openCardTool) {
                    EmptyView()
                }
            }
            .navigationTitle("Boss Monty")
            .navigationBarTitleDisplayMode(.inline)
            .background(
                Color(red: 0.90, green: 0.80, blue: 0.65)
                    .ignoresSafeArea()
            )
            .onAppear {
                if viewModel.messages.isEmpty {
                    addMontyMessages([
                        "Hey! You're the new intern they assigned me.",
                        "It's great to meet you, uh-um... what's your name?"
                    ]) {
                        viewModel.step = 2
                    }
                }
            }
        }
    }

    func addMontyMessages(_ lines: [String], completion: @escaping () -> Void) {
        guard !lines.isEmpty else {
            completion()
            return
        }
        viewModel.isTyping = true
        typeMessage(lines[0]) {
            addMontyMessages(Array(lines.dropFirst()), completion: completion)
        }
    }

    func typeMessage(_ fullText: String, completion: @escaping () -> Void) {
        var displayText = ""
        let chars = Array(fullText)
        var index = 0

        Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { timer in
            if index < chars.count {
                displayText.append(chars[index])
                index += 1
                if viewModel.messages.last?.text == displayText.dropLast().description {
                    viewModel.messages[viewModel.messages.count - 1].text = displayText
                } else {
                    viewModel.messages.append(ChatMessage(text: displayText, isFromBoss: true))
                }
            } else {
                timer.invalidate()
                viewModel.isTyping = false
                completion()
            }
        }
    }
}


