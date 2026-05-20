import SwiftUI

@main
struct GGSBreathApp: App {
    @AppStorage("shouldShowOnboarding") private var shouldShowOnboarding: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if shouldShowOnboarding {
                OnboardingContainerView(shouldShowOnboarding: $shouldShowOnboarding)
            } else {
                MainMenuView()
            }
        }
    }
}

extension Font {
    static func sfRounded(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return .system(size: size, weight: weight, design: .rounded)
    }
}
