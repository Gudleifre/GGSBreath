import SwiftUI
import Combine
import SwiftData

enum SessionState {
    case countdown
    case breathing
    case pausedDuringCountdown
    case paused
    case completed
}

enum BreathingPhase: String {
    case inhale
    case holdIn
    case exhale
    case holdOut
    
    var localizedTitle: LocalizedStringKey {
        switch self {
        case .inhale: return "Вдохните через нос"
        case .holdIn: return "Задержка на вдохе"
        case .exhale: return "Выдохните через рот"
        case .holdOut: return "Задержка на выдохе"
        }
    }
}

class PracticeViewModel: ObservableObject {
    
    let practice: BreathingPractice
    
    @Published var sessionState: SessionState = .countdown
    @Published var countdownCount: Int = 3
    private var countdownTicks: Double = 0.0
    
    @Published var currentPhase: BreathingPhase = .inhale
    @Published var currentCycle: Int = 1
    
    @Published var totalSecondsRemaining: Int = 0
    @Published var phaseProgress: Double = 0.0
    
    private var timer: AnyCancellable?
    private var totalTimeRemainingTicks: Double = 0.0
    private var phaseSecondsElapsed: Double = 0.0
    private let timeStep: Double = 0.02
    
    private var inhaleDuration: Double = 4.0
    private var holdInDuration: Double = 0.0
    private var exhaleDuration: Double = 8.0
    private var holdOutDuration: Double = 0.0
    
    var maxCycles: Int = 1
    
    init(practice: BreathingPractice) {
        self.practice = practice
        setupPracticeMetrics()
    }
    
    private func setupPracticeMetrics() {
        var targetMinutes: Double = 5.0
        
        switch practice.title {
        case "Спокойствие":
            inhaleDuration = 4.0; holdInDuration = 7.0; exhaleDuration = 8.0; holdOutDuration = 0.0
            targetMinutes = 5.0 
        case "Энергия":
            inhaleDuration = 2.0; holdInDuration = 0.0; exhaleDuration = 1.0; holdOutDuration = 0.0
            targetMinutes = 3.0
        case "Фокус":
            inhaleDuration = 4.0; holdInDuration = 4.0; exhaleDuration = 4.0; holdOutDuration = 4.0
            targetMinutes = 4.0
        case "Сон":
            inhaleDuration = 4.0; holdInDuration = 0.0; exhaleDuration = 8.0; holdOutDuration = 0.0
            targetMinutes = 10.0
        default:
            inhaleDuration = 4.0; holdInDuration = 4.0; exhaleDuration = 4.0; holdOutDuration = 0.0
            targetMinutes = 5.0
        }
        
        let singleCycleDuration = inhaleDuration + holdInDuration + exhaleDuration + holdOutDuration
        
        let targetSeconds = targetMinutes * 60.0
        
        self.maxCycles = Int(round(targetSeconds / singleCycleDuration))
        
        self.totalTimeRemainingTicks = singleCycleDuration * Double(maxCycles)
        self.totalSecondsRemaining = Int(ceil(totalTimeRemainingTicks))
    }
    
    func startSession() {
        timer = Timer.publish(every: timeStep, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.gameTick()
            }
    }
    
    func pauseSession() {
        if sessionState == .countdown {
            sessionState = .pausedDuringCountdown
        } else {
            sessionState = .paused
        }
        timer?.cancel()
        HapticManager.shared.triggerImpact(style: .light)
    }
    
    func resumeSession() {
        if sessionState == .pausedDuringCountdown {
            sessionState = .countdown
        } else {
            sessionState = .breathing
        }
        startSession()
        HapticManager.shared.triggerImpact(style: .light)
    }
    
    func restartSession() {
        timer?.cancel()
        sessionState = .countdown
        countdownCount = 3
        countdownTicks = 0.0
        currentPhase = .inhale
        phaseSecondsElapsed = 0.0
        currentCycle = 1
        phaseProgress = 0.0
        startSession()
        HapticManager.shared.triggerImpact(style: .medium)
    }
    
    func endSession() {
        timer?.cancel()
    }
    
    func saveSession(context: ModelContext) {
        let newRecord = BreathingHistory(
            durationInMinutes: Int(practice.duration.replacingOccurrences(of: " мин", with: "")) ?? 5,
            practiceTitle: practice.title
        )
        
        context.insert(newRecord)
        
        try? context.save()
        print("Сессия успешно сохранена в SwiftData!")
    }
    
    private func gameTick() {
        if sessionState == .countdown {
            countdownTicks += timeStep
            if countdownTicks >= 1.0 {
                if countdownCount > 1 {
                    countdownCount -= 1
                    countdownTicks = 0.0
                    HapticManager.shared.triggerImpact(style: .light)
                } else {
                    sessionState = .breathing
                    countdownCount = 0
                    phaseSecondsElapsed = 0.0
                    phaseProgress = 0.0
                    currentPhase = .inhale
                    HapticManager.shared.triggerImpact(style: .medium)
                }
            }
            return
        }
        
        if totalTimeRemainingTicks > timeStep {
            totalTimeRemainingTicks -= timeStep
        } else {
            totalTimeRemainingTicks = 0.0
        }
        self.totalSecondsRemaining = Int(ceil(totalTimeRemainingTicks))
        
        phaseSecondsElapsed += timeStep
        let targetDuration = currentPhaseDuration()
        
        phaseProgress = min(phaseSecondsElapsed / targetDuration, 1.0)
        
        if phaseSecondsElapsed >= targetDuration {
            phaseSecondsElapsed = 0.0
            phaseProgress = 0.0
            goToNextPhase()
        }
    }
    
    private func currentPhaseDuration() -> Double {
        switch currentPhase {
        case .inhale: return inhaleDuration
        case .holdIn: return holdInDuration
        case .exhale: return exhaleDuration
        case .holdOut: return holdOutDuration
        }
    }
    
    private func goToNextPhase() {
        HapticManager.shared.triggerImpact(style: .medium)
        
        switch currentPhase {
        case .inhale:
            if holdInDuration > 0 { currentPhase = .holdIn }
            else { currentPhase = .exhale }
        case .holdIn:
            currentPhase = .exhale
        case .exhale:
            if holdOutDuration > 0 { currentPhase = .holdOut }
            else { advanceCycle() }
        case .holdOut:
            advanceCycle()
        }
    }
    
    private func advanceCycle() {
        if currentCycle < maxCycles {
            currentCycle += 1
            currentPhase = .inhale
        } else {
            sessionState = .completed
            timer?.cancel()
            HapticManager.shared.triggerImpact(style: .heavy)
        }
    }
    
    func formatTotalTime() -> String {
        let minutes = totalSecondsRemaining / 60
        let seconds = totalSecondsRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
