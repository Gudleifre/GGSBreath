import SwiftUI

struct BreathingPractice: Identifiable {
    let id = UUID()
    let title: String
    let duration: String
    let cycles: LocalizedStringKey
    let purpose: LocalizedStringKey
    let technique: LocalizedStringKey
    let color: Color
}
