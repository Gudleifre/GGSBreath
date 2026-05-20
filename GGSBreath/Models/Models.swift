import SwiftUI

struct OnboardingPage: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let pageIndex: Int
}

struct BreathingPractice: Identifiable {
    let id = UUID()
    let title: String
    let duration: String
    let cycles: String
    let purpose: String
    let technique: String
    let color: Color   
}
