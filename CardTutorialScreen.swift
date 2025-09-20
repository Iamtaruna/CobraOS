import SwiftUI

struct CardTutorialScreen: View {
    @State private var showOS: Bool = true
    @State private var showBootText: Bool = false
    @State private var showIcons: Bool = false
    @State private var bootDots: String = ""
    @State private var bootTimer: Timer?
    @State private var bounce = false
    @State private var navigateToTutorial = false

    @Namespace private var animationNamespace
    @AppStorage("playerName") private var playerName: String = "Intern"

    var body: some View {
        NavigationView {
            ZStack {
                if showOS {
                    ZStack {
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 254/255, green: 241/255, blue: 219/255),
                                Color(red: 255/255, green: 233/255, blue: 200/255)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .ignoresSafeArea()
                        .matchedGeometryEffect(id: "osTransition", in: animationNamespace)

                        VStack(spacing: 0) {
                            MacHeaderBar()
                            Spacer(minLength: 60)

                            if !showBootText {
                                Text("Booting up CobraOS\(bootDots)")
                                    .font(.system(size: 16, weight: .medium, design: .monospaced))
                                    .transition(.opacity)
                                    .onAppear(perform: startBootSequence)
                            } else if !showIcons {
                                Text("Welcome back, \(playerName).")
                                    .font(.system(size: 16, weight: .semibold, design: .monospaced))
                                    .scaleEffect(showIcons ? 1.0 : 0.9)
                                    .opacity(showBootText ? 1.0 : 0)
                                    .animation(.easeOut(duration: 0.4), value: showIcons)
                                    .transition(.opacity)
                            } else {
                                GeometryReader { geometry in
                                    ZStack(alignment: .topLeading) {
                                        DesktopIcon(
                                            image: "GreetingCardIcon",
                                            label: "",
                                            onTap: {
                                                withAnimation(.easeInOut(duration: 0.3)) {
                                                    navigateToTutorial = true
                                                }
                                            },
                                            size: 90
                                        )
                                        .offset(y: bounce ? -6 : 0)
                                        .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: bounce)
                                        .padding(.top, -10)
                                        .padding(.leading, 20)

                                        NavigationLink(
                                            destination: GreetingCardTutorialScreen(),
                                            isActive: $navigateToTutorial,
                                            label: { EmptyView() }
                                        )
                                        .hidden()
                                    }
                                }
                                .transition(.opacity)
                            }

                            Spacer()
                        }
                        .foregroundColor(.black)
                        .animation(.easeInOut(duration: 0.4), value: showBootText)
                        .animation(.easeInOut(duration: 0.4), value: showIcons)
                    }
                }
            }
        }
    }

    func startBootSequence() {
        var dotCount = 0
        bootTimer?.invalidate()
        bootTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { timer in
            if dotCount >= 3 {
                bootDots = ""
                dotCount = 0
            } else {
                dotCount += 1
                bootDots = String(repeating: ".", count: dotCount)
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
            bootTimer?.invalidate()
            withAnimation(.easeInOut(duration: 0.4)) {
                showBootText = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                withAnimation(.easeInOut(duration: 0.4)) {
                    showIcons = true
                }
                bounce = true
            }
        }
    }
}

// MARK: - Header Bar
struct MacHeaderBar: View {
    var body: some View {
        HStack {
            HStack(spacing: 8) {
                Circle().fill(Color.red).frame(width: 10, height: 10)
                Circle().fill(Color.yellow).frame(width: 10, height: 10)
                Circle().fill(Color.green).frame(width: 10, height: 10)
            }
            .padding(.leading, 10)

            Spacer()

            Text("CobraOS")
                .font(.custom("Chalkboard SE", size: 14))
                .foregroundColor(.black.opacity(0.6))

            Spacer()

            HStack(spacing: 12) {
                Image(systemName: "wifi")
                Image(systemName: "battery.100")
                Image(systemName: "person.crop.circle")
            }
            .font(.system(size: 14))
            .padding(.trailing, 12)
        }
        .frame(height: 28)
        .background(Color.white.opacity(0.8))
        .overlay(Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.2)), alignment: .bottom)
    }
}

// MARK: - Desktop Icon
struct DesktopIcon: View {
    var image: String
    var label: String
    var isDisabled: Bool = false
    var onTap: (() -> Void)? = nil
    var size: CGFloat = 70

    @State private var isPressed = false

    var body: some View {
        VStack(spacing: 6) {
            Image(image)
                .resizable()
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white, lineWidth: 2)
                )
                .opacity(isDisabled ? 0.3 : 1.0)
                .saturation(isDisabled ? 0 : 1.0)
                .shadow(radius: isDisabled ? 0 : 5)
                .scaleEffect(isPressed ? 1.05 : 1.0)
                .animation(.easeInOut(duration: 0.15), value: isPressed)
                .onLongPressGesture(minimumDuration: 0.05, pressing: { pressing in
                    if !isDisabled {
                        isPressed = pressing
                    }
                }, perform: {
                    if let action = onTap, !isDisabled {
                        action()
                    }
                })

            Text(label)
                .font(.custom("Chalkboard SE", size: 14))
                .foregroundColor(.black.opacity(isDisabled ? 0.4 : 1.0))
        }
        .opacity(isDisabled ? 0.5 : 1.0)
    }
}

// MARK: - Preview
struct CardTutorialScreen_Previews: PreviewProvider {
    static var previews: some View {
        CardTutorialScreen()
    }
}
