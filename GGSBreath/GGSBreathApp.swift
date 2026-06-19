import SwiftUI

@main
struct GGSBreathApp: App {
    @State private var showSplash: Bool = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                MainMenuView()
                
                if showSplash {
                    SplashScreenView(onFinished: {
                        withAnimation(.easeOut(duration: 1.4)) {
                            showSplash = false
                        }
                    })
                    .transition(.opacity)
                }
            }
        }
    }
}

extension Font {
    static func sfRounded(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return .system(size: size, weight: weight, design: .rounded)
    }
}
