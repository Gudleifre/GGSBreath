import SwiftUI

enum PracticeKind: String, CaseIterable, Identifiable {
    case calm
    case energy
    case focus
    case sleep

    var id: String { rawValue }

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

    var cycles: LocalizedStringKey {
        switch self {
        case .calm: "16 cycles"
        case .energy: "60 cycles"
        case .focus: "15 cycles"
        case .sleep: "50 cycles"
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

    var durationMinutes: Int {
        switch self {
        case .calm: 5
        case .energy: 3
        case .focus: 4
        case .sleep: 10
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

struct BreathingPractice: Identifiable {
    let id = UUID()
    let kind: PracticeKind

    var title: LocalizedStringKey { kind.title }
    var duration: LocalizedStringKey { kind.duration }
    var cycles: LocalizedStringKey { kind.cycles }
    var purpose: LocalizedStringKey { kind.purpose }
    var technique: LocalizedStringKey { kind.technique }
    var color: Color { kind.color }

    init(kind: PracticeKind) {
        self.kind = kind
    }
}
