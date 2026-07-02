import SwiftUI

struct SessionPracticeView: View {
    @StateObject var viewModel: PracticeViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var circlesOpacity: Double = 0.0
    @State private var circlesScale: CGFloat = 0.8
    @State private var showCheckmark = false
    
    private var isCountdownPhase: Bool {
        viewModel.sessionState == .countdown || viewModel.sessionState == .pausedDuringCountdown
    }
    
    private var isPaused: Bool {
        viewModel.sessionState == .paused || viewModel.sessionState == .pausedDuringCountdown
    }
    
    var body: some View {
        ZStack {
            viewModel.kind.color.ignoresSafeArea()
            
            VStack(spacing: 0) {
                topBar
                Spacer()
                centerContent
                Spacer()
                infoBlock
                Spacer()
                
                if viewModel.sessionState == .completed {
                    doneButton
                } else {
                    controlPanel
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.startSession()
        }
        .onDisappear {
            viewModel.endSession()
        }
        .onChange(of: scenePhase) { _, newPhase in
            viewModel.handleScenePhase(newPhase)
        }
    }
    
    private var topBar: some View {
        HStack {
            Text(viewModel.formatTotalTime())
                .font(.sfRounded(size: 16, weight: .bold))
                .foregroundColor(.whiteGGS)
                .opacity(viewModel.sessionState == .completed ? 0.0 : 1.0)
                .animation(.easeInOut(duration: 0.5), value: viewModel.sessionState)
            
            Spacer()
            
            Button {
                viewModel.endSession()
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.whiteGGS)
                    .frame(width: 36, height: 36)
                    .background(Color.whiteGGS.opacity(0.2))
                    .clipShape(Circle())
            }
            .accessibilityLabel("Close session")
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
    }
    
    private var centerContent: some View {
        ZStack {
            if isCountdownPhase {
                Text("\(viewModel.countdownCount)")
                    .font(.sfRounded(size: 90, weight: .bold))
                    .foregroundColor(.whiteGGS)
                    .transition(.scale.combined(with: .opacity))
            }
            
            if showCheckmark {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 100, weight: .light))
                    .foregroundColor(.whiteGGS)
                    .transition(.scale(scale: 0.8).combined(with: .opacity))
            }
            
            if !isCountdownPhase && viewModel.sessionState != .completed {
                breathingCircles
            }
        }
        .frame(height: 340)
        .onChange(of: viewModel.sessionState) { _, newValue in
            guard newValue == .completed else { return }
            viewModel.saveSession(context: modelContext)
            withAnimation(.easeIn(duration: 1.2)) {
                circlesOpacity = 0.0
                circlesScale = 0.3
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                withAnimation(.easeOut(duration: 0.8)) {
                    showCheckmark = true
                }
            }
        }
    }
    
    private var breathingCircles: some View {
        ZStack {
            Circle()
                .fill(Color.whiteGGS.opacity(0.15))
                .frame(width: 302, height: 302)
            
            Circle()
                .fill(Color.whiteGGS.opacity(0.25))
                .frame(width: currentMiddleCircleSize(), height: currentMiddleCircleSize())
            
            Circle()
                .fill(Color.whiteGGS.opacity(isHolding() ? 0.8 : 1.0))
                .frame(width: 96, height: 96)
            
            Circle()
                .trim(from: 0, to: CGFloat(currentRingProgress()))
                .stroke(
                    Color.whiteGGS,
                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                )
                .frame(width: 314, height: 314)
                .rotationEffect(.degrees(-90))
        }
        .opacity(circlesOpacity)
        .scaleEffect(circlesScale)
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                circlesOpacity = 1.0
                circlesScale = 1.0
            }
        }
    }
    
    private var infoBlock: some View {
        VStack(spacing: 12) {
            Text(sessionStatusTitle)
                .font(.sfRounded(size: 20, weight: .bold))
                .foregroundColor(.whiteGGS)
                .multilineTextAlignment(.center)
                .id(viewModel.currentPhase)
            
            Text("Cycle: \(viewModel.currentCycle) of \(viewModel.maxCycles)")
                .font(.sfRounded(size: 16, weight: .medium))
                .foregroundColor(.whiteGGS.opacity(0.7))
                .opacity(viewModel.sessionState == .completed ? 0.0 : 1.0)
                .animation(.easeInOut, value: viewModel.sessionState)
        }
        .padding(.horizontal, 40)
    }
    
    private var sessionStatusTitle: LocalizedStringKey {
        if isCountdownPhase {
            "Get ready"
        } else if viewModel.sessionState == .completed {
            "Great work!"
        } else {
            viewModel.currentPhase.localizedTitle
        }
    }
    
    private var controlPanel: some View {
        HStack(spacing: 40) {
            Button {
                circlesOpacity = 0.0
                circlesScale = 0.8
                showCheckmark = false
                viewModel.restartSession()
            } label: {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.whiteGGS)
                    .frame(width: 56, height: 56)
                    .background(Color.whiteGGS.opacity(0.2))
                    .clipShape(Circle())
            }
            .accessibilityLabel("Restart session")
            
            Button {
                if isPaused {
                    viewModel.resumeSession()
                } else {
                    viewModel.pauseSession()
                }
            } label: {
                Image(systemName: isPaused ? "play.fill" : "pause.fill")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(viewModel.kind.color)
                    .frame(width: 76, height: 76)
                    .background(Color.whiteGGS)
                    .clipShape(Circle())
            }
            .accessibilityLabel(isPaused ? "Resume session" : "Pause session")
            
            Spacer().frame(width: 56, height: 56)
        }
        .padding(.bottom, 40)
    }
    
    private var doneButton: some View {
        Button {
            viewModel.endSession()
            dismiss()
        } label: {
            Text("Done")
                .font(.sfRounded(size: 20, weight: .bold))
                .foregroundColor(.whiteGGS)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.whiteGGS.opacity(0.2))
                .clipShape(Capsule())
                .padding(.horizontal, 74)
        }
        .padding(.bottom, 40)
        .transition(.opacity)
    }
    
    private func currentMiddleCircleSize() -> CGFloat {
        let minSize: CGFloat = 96
        let maxSize: CGFloat = 302
        
        switch viewModel.currentPhase {
        case .inhale:
            return minSize + (maxSize - minSize) * CGFloat(viewModel.phaseProgress)
        case .holdIn:
            return maxSize
        case .exhale:
            return maxSize - (maxSize - minSize) * CGFloat(viewModel.phaseProgress)
        case .holdOut:
            return minSize
        }
    }
    
    private func currentRingProgress() -> Double {
        if viewModel.currentPhase == .holdIn || viewModel.currentPhase == .holdOut {
            return viewModel.phaseProgress
        }
        return 0.0
    }
    
    private func isHolding() -> Bool {
        viewModel.currentPhase == .holdIn || viewModel.currentPhase == .holdOut
    }
}
