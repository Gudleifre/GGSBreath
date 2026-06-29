import SwiftUI
import SwiftData

@main
struct GGSBreathApp: App {
    @State private var showSplash: Bool = true
    @State private var selectedTab: Int = 0
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                TabView(selection: $selectedTab) {
                    MainMenuView()
                        .tabItem { Image(systemName: "lungs.fill") }
                        .tag(0)
                    
                    StatisticsView()
                        .tabItem { Image(systemName: "chart.bar.fill") }
                        .tag(1)
                }
                .accentColor(.blueGGS)
                .onAppear {
                    let appearance = UITabBarAppearance()
                    appearance.backgroundColor = UIColor.blackGGS.withAlphaComponent(0.4)
                    
                    UITabBar.appearance().standardAppearance = appearance
                }
                
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
        .modelContainer(for: BreathingHistory.self)
    }
}

extension Font {
    static func sfRounded(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return .system(size: size, weight: weight, design: .rounded)
    }
}
