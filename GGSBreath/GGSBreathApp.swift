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

struct OnboardingContainerView: View {
    @Binding var shouldShowOnboarding: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Экран Онбординга (3 страницы)")
                .font(.sfRounded(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Button(action: {
                // Переключаем состояние, и SwiftUI автоматически обновит интерфейс на MainMenuView
                shouldShowOnboarding = false
            }) {
                Text("Пропустить онбординг")
                    .font(.sfRounded(size: 18, weight: .medium))
                    .foregroundColor(.blue)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea()) // Твой темный фон из Фигмы
    }
}

struct MainMenuView: View {
    var body: some View {
        VStack {
            Text("Главный экран с 4 ячейками")
                .font(.sfRounded(size: 24, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
    }
}
