import SwiftUI

struct BreathingPractice: Identifiable {
    let id = UUID()
    let title: LocalizedStringKey
    let duration: LocalizedStringKey
    let cycles: LocalizedStringKey
    let purpose: LocalizedStringKey
    let technique: LocalizedStringKey
    let color: Color
}
