import SwiftUI

@main
struct GGSBreathApp: App {
    @State private var showSplash: Bool = true
    @State private var selectedTab: Int = 0
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                TabView(selection: $selectedTab) {
                    MainMenuView()
                        .tabItem {
                            Label("", systemImage: "lungs.fill")
                        }
                        .tag(0)
                    
                    StatisticsView()
                        .tabItem {
                            Label("", systemImage: "chart.bar.fill")
                        }
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
    }
}

extension Font {
    static func sfRounded(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return .system(size: size, weight: weight, design: .rounded)
    }
}
