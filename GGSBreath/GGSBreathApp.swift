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

struct OnboardingPage: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let pageIndex: Int
}

struct BreathingPractice: Identifiable {
    let id = UUID()
    let title: String
    let color: Color
}

// MARK: - ЭКРАН: Главное Меню (MainMenuView)
struct MainMenuView: View {
    let practices = [
        BreathingPractice(title: "Спокойствие", color: .blueGGS),
        BreathingPractice(title: "Энергия", color: .redGGS),
        BreathingPractice(title: "Фокус", color: .purpleGGS),
        BreathingPractice(title: "Сон", color: .darkBlueGGS)
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack(spacing: 2) {
                    Text("G.G.S")
                        .font(.sfRounded(size: 20, weight: .bold))
                        .foregroundColor(.whiteGGS)
                    
                    Text("|")
                        .font(.sfRounded(size: 20, weight: .bold))
                        .foregroundColor(.blueGGS)
                    
                    Text("Breath")
                        .font(.sfRounded(size: 20, weight: .bold))
                        .foregroundColor(.whiteGGS)
                }
                .padding(.top, 20)
                .padding(.bottom, 30)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        ForEach(practices) { practice in
                            NavigationLink(destination: DetailPracticeView(practice: practice)) {
                                PracticeRowView(practice: practice)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 60)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.blackGGS.ignoresSafeArea())
        }
    }
}

// MARK: - Вью упрощенной ячейки (Капсула без иконок)
struct PracticeRowView: View {
    let practice: BreathingPractice
    
    var body: some View {
        HStack {
            Spacer()
            
            Text(practice.title)
                .font(.sfRounded(size: 24, weight: .bold))
                .foregroundColor(.whiteGGS)
            
            Spacer()
        }
        .frame(height: 120)
        .background(practice.color)
        .clipShape(Capsule())
    }
}

// MARK: - ВРЕМЕННЫЙ ЭКРАН: Детали практики (Заглушка для проверки перехода)
struct DetailPracticeView: View {
    let practice: BreathingPractice
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text(practice.title)
                .font(.sfRounded(size: 32, weight: .bold))
                .foregroundColor(.whiteGGS)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(practice.color.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .overlay(
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.whiteGGS)
                    .padding()
            },
            alignment: .topLeading
        )
    }
}

// MARK: - Онбординг
struct OnboardingContainerView: View {
    @Binding var shouldShowOnboarding: Bool
    @State private var currentPage = 0
    
    let pages = [
        OnboardingPage(
            title: "Дыши осознанно",
            subtitle: "Найди свой внутренний баланс через простые дыхательные практики",
            pageIndex: 0
        ),
        OnboardingPage(
            title: "Следуй за светом",
            subtitle: "Просто наблюдай за анимацией. Она подскажет, когда сделать вдох, задержку или выдох",
            pageIndex: 1
        ),
        OnboardingPage(
            title: "Время для себя",
            subtitle: "Всего 5 минут в день помогут снизить стресс и улучшить концентрацию",
            pageIndex: 2
        )
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentPage) {
                ForEach(pages) { page in
                    OnboardingPageView(page: page)
                        .tag(page.pageIndex)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            // Кастомная нижняя панель: индикатор (точки) и кнопка
            VStack(spacing: 32) {
                // Индикатор страниц (3 точки)
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(currentPage == index ? Color.blueGGS : Color.grayGGS)
                            .frame(width: 8, height: 8)
                            .animation(.spring(), value: currentPage)
                    }
                }
                
                if currentPage == 2 {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            shouldShowOnboarding = false
                        }
                    }) {
                        Text("Начать")
                            .font(.sfRounded(size: 24, weight: .bold))
                            .foregroundColor(.whiteGGS)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(.blueGGS)
                            .cornerRadius(1000)
                            .padding(.horizontal, 74)
                    }
                    .transition(.opacity.combined(with: .scale))
                } else {
                    Color.clear.frame(height: 60)
                }
            }
            .padding(.bottom, 50)
        }
        .background(Color.blackGGS.ignoresSafeArea())
    }
}
// MARK: - Верстка отдельной страницы онбординга
struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var isHeartBeating = false
    @State private var isCircleExpanding = false
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                Text(page.title)
                    .font(.sfRounded(size: 36, weight: .bold))
                    .foregroundColor(.whiteGGS)
                    .multilineTextAlignment(.center)
                
                Text(page.subtitle)
                    .font(.sfRounded(size: 18, weight: .bold))
                    .foregroundColor(.grayGGS)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            .padding(.top, 80)
            
            Spacer()
            
            ZStack {
                if page.pageIndex == 0 {
                    Circle()
                        .fill(Color.lightBlueGGS.opacity(0.8))
                        .frame(width: 302, height: 302)
                        .blur(radius: 8)
                    
                    Circle()
                        .fill(Color.whiteGGS.opacity(0.6))
                        .frame(width: 96, height: 96)
                        .blur(radius: 2)
                    
                } else if page.pageIndex == 1 {
                    Circle()
                        .fill(Color.lightBlueGGS.opacity(0.8))
                        .frame(width: 302, height: 302)
                        .blur(radius: 8)
                    
                    Circle()
                        .fill(Color.whiteGGS.opacity(0.6))
                        .frame(width: 240, height: 240)
                        .blur(radius: 8)
                        .scaleEffect(isCircleExpanding ? 1.2 : 0.5)
                        .animation(
                            Animation.easeInOut(duration: 2.5)
                                .repeatForever(autoreverses: true),
                            
                            value: isCircleExpanding
                        )
                        .onAppear {
                            isCircleExpanding = true
                        }
                    
                    Circle()
                        .fill(Color.whiteGGS.opacity(0.6))
                        .frame(width: 96, height: 96)
                        .blur(radius: 2)
                    
                } else {
                    Circle()
                        .fill(Color.lightBlueGGS.opacity(0.8))
                        .frame(width: 302, height: 302)
                        .blur(radius: 8)
                    
                    Circle()
                        .fill(Color.whiteGGS.opacity(0.6))
                        .frame(width: 288, height: 288)
                        .blur(radius: 8)
                    
                    Image(systemName: "heart.fill")
                        .font(.system(size: 96))
                        .foregroundColor(.whiteGGS.opacity(0.6))
                        .blur(radius: 2)
                        .scaleEffect(isHeartBeating ? 1.2 : 1.1)
                        .animation(
                            Animation.easeInOut(duration: 0.8)
                                .repeatForever(autoreverses: true),
                            value: isHeartBeating
                        )
                        .onAppear {
                            isHeartBeating = true
                        }
                }
            }
            .frame(height: 300)
            .padding(.bottom, 160)
            
            Spacer()
        }
    }
}
