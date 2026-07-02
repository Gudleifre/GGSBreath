import SwiftUI
import SwiftData

@main
struct GGSBreathApp: App {
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                TabView {
                    MainMenuView()
                        .tabItem {
                            Label("Practice", systemImage: "lungs.fill")
                        }
                    
                    StatisticsView()
                        .tabItem {
                            Label("Statistics", systemImage: "chart.bar.fill")
                        }
                }
                .accentColor(.blueGGS)
                .onAppear {
                    configureTabBarAppearance()
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
    
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor.blackGGS.withAlphaComponent(0.4)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
