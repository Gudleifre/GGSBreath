import SwiftUI

struct BreathingPattern {
    let inhale: Double
    let holdIn: Double
    let exhale: Double
    let holdOut: Double
    let targetMinutes: Double
    
    var cycleDuration: Double {
        inhale + holdIn + exhale + holdOut
    }
    
    var maxCycles: Int {
        Int(round(targetMinutes * 60 / cycleDuration))
    }
    
    var totalSeconds: Double {
        cycleDuration * Double(maxCycles)
    }
}

enum PracticeKind: String, CaseIterable, Identifiable {
    case calm
    case energy
    case focus
    case sleep
    
    var id: String { rawValue }
    
    var pattern: BreathingPattern {
        switch self {
        case .calm:
            BreathingPattern(inhale: 4, holdIn: 7, exhale: 8, holdOut: 0, targetMinutes: 5)
        case .energy:
            BreathingPattern(inhale: 2, holdIn: 0, exhale: 1, holdOut: 0, targetMinutes: 3)
        case .focus:
            BreathingPattern(inhale: 4, holdIn: 4, exhale: 4, holdOut: 4, targetMinutes: 4)
        case .sleep:
            BreathingPattern(inhale: 4, holdIn: 0, exhale: 8, holdOut: 0, targetMinutes: 10)
        }
    }
    
    var maxCycles: Int { pattern.maxCycles }
    
    var durationMinutes: Int { Int(pattern.targetMinutes) }
    
    var title: LocalizedStringKey {
        switch self {
        case .calm: "Calm"
        case .energy: "Energy"
        case .focus: "Focus"
        case .sleep: "Sleep"
        }
    }
    
    var duration: LocalizedStringKey {
        switch self {
        case .calm: "5 min"
        case .energy: "3 min"
        case .focus: "4 min"
        case .sleep: "10 min"
        }
    }
    
    var purpose: LocalizedStringKey {
        switch self {
        case .calm:
            "Helps relieve anxiety quickly and calm your nervous system."
        case .energy:
            "A pick-me-up instead of a second cup of coffee. Helps you wake up and feel energized."
        case .focus:
            "Steadies your attention and improves concentration."
        case .sleep:
            "Deeply relaxes body and mind, quiets thoughts, and prepares you for sleep."
        }
    }
    
    var technique: LocalizedStringKey {
        switch self {
        case .calm:
            "Inhale for 4 sec, hold for 7 sec, slow exhale for 8 sec."
        case .energy:
            "Active breathing (2 sec inhale — 1 sec exhale, rapid cycle)."
        case .focus:
            "Equal inhale, hold, exhale, and hold — 4 seconds each."
        case .sleep:
            "Inhale for 4 sec and a long, slow exhale for 8 sec."
        }
    }
    
    var color: Color {
        switch self {
        case .calm: .blueGGS
        case .energy: .redGGS
        case .focus: .purpleGGS
        case .sleep: .darkBlueGGS
        }
    }
}
