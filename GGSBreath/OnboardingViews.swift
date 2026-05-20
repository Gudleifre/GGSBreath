import SwiftUI

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
            
            VStack(spacing: 32) {
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
// MARK: - OnboardingSinglePage
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
