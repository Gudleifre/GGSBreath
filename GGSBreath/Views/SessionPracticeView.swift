import SwiftUI

struct SessionPracticeView: View {
    @StateObject var viewModel: PracticeViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            viewModel.practice.color.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top panel
                HStack {
                    Text(viewModel.formatTotalTime())
                        .font(.sfRounded(size: 16, weight: .bold))
                        .foregroundColor(.whiteGGS)
                    Spacer()
                    Button(action: {
                        viewModel.endSession()
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.whiteGGS)
                            .frame(width: 36, height: 36)
                            .background(Color.whiteGGS.opacity(0.2))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                Spacer()
                
                // Central part
                ZStack {
                    if viewModel.sessionState == .countdown ||
                        viewModel.sessionState == .pausedDuringCountdown {
                        Text("\(viewModel.countdownCount)")
                            .font(.sfRounded(size: 90, weight: .bold))
                            .foregroundColor(.whiteGGS)
                            .transition(.scale.combined(with: .opacity))
                    } else {
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
                    }
                }
                .frame(height: 340)
                
                Spacer()
                
                // Information block
                VStack(spacing: 12) {
                    Text(
                        (viewModel.sessionState == .countdown || viewModel.sessionState == .pausedDuringCountdown)
                        ? "Приготовьтесь"
                        : (viewModel.sessionState == .completed ? "Отличная работа!" : viewModel.currentPhase.rawValue))
                    .font(.sfRounded(size: 20, weight: .bold)
                    )
                    .foregroundColor(.whiteGGS)
                    .multilineTextAlignment(.center)
                    .id(viewModel.currentPhase)
                    
                    Text("Цикл: \(viewModel.currentCycle) из \(viewModel.maxCycles)")
                        .font(.sfRounded(size: 16, weight: .medium))
                        .foregroundColor(.whiteGGS.opacity(0.7))
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                // Control panel
                HStack(spacing: 40) {
                    Button(action: { viewModel.restartSession() }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.whiteGGS)
                            .frame(width: 56, height: 56)
                            .background(Color.whiteGGS.opacity(0.2))
                            .clipShape(Circle())
                    }
                    
                    Button(action: {
                        if viewModel.sessionState == .paused || viewModel.sessionState == .pausedDuringCountdown {
                            viewModel.resumeSession()
                        } else {
                            viewModel.pauseSession()
                        }
                    }) {
                        Image(systemName: (viewModel.sessionState == .paused || viewModel.sessionState == .pausedDuringCountdown) ? "play.fill" : "pause.fill")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(viewModel.practice.color)
                            .frame(width: 76, height: 76)
                            .background(Color.whiteGGS)
                            .clipShape(Circle())
                    }
                    
                    Spacer().frame(width: 56, height: 56)
                }
                .padding(.bottom, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.startSession()
        }
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
        return viewModel.currentPhase == .holdIn || viewModel.currentPhase == .holdOut
    }
}
