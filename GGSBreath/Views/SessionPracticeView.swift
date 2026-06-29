import SwiftUI

struct SessionPracticeView: View {
    @StateObject var viewModel: PracticeViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var circlesOpacity: Double = 0.0
    @State private var circlesScale: CGFloat = 0.8
    @State private var showCheckmark: Bool = false
    
    var body: some View {
        ZStack {
            viewModel.practice.color.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top panel
                HStack {
                    Text(viewModel.formatTotalTime())
                        .font(.sfRounded(size: 16, weight: .bold))
                        .foregroundColor(.whiteGGS)
                        .opacity(viewModel.sessionState == .completed ? 0.0 : 1.0)
                        .animation(.easeInOut(duration: 0.5), value: viewModel.sessionState)
                    
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
                    }
                    if showCheckmark {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 100, weight: .light))
                            .foregroundColor(.whiteGGS)
                            .transition(.scale(scale: 0.8).combined(with: .opacity))
                        
                    }
                    if viewModel.sessionState != .countdown && viewModel.sessionState != .pausedDuringCountdown {
                        
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
                }
                .frame(height: 340)
                .onChange(of: viewModel.sessionState) { oldValue, newValue in
                    if newValue == .completed {
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
                
                Spacer()
                
                // Information block
                VStack(spacing: 12) {
                    Text(
                        (viewModel.sessionState == .countdown || viewModel.sessionState == .pausedDuringCountdown)
                        ? LocalizedStringKey("Приготовьтесь")
                        : (viewModel.sessionState == .completed ? LocalizedStringKey("Отличная работа!") : viewModel.currentPhase.localizedTitle)
                    )
                    .font(.sfRounded(size: 20, weight: .bold)
                    )
                    .foregroundColor(.whiteGGS)
                    .multilineTextAlignment(.center)
                    .id(viewModel.currentPhase)
                    
                    Text("Цикл: \(viewModel.currentCycle) из \(viewModel.maxCycles)")
                        .font(.sfRounded(size: 16, weight: .medium))
                        .foregroundColor(.whiteGGS.opacity(0.7))
                        .opacity(viewModel.sessionState == .completed ? 0.0 : 1.0)
                        .animation(.easeInOut, value: viewModel.sessionState)
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                // Control panel
                HStack(spacing: 40) {
                    Button(action: {
                        circlesOpacity = 0.0
                        circlesScale = 0.8
                        viewModel.restartSession() }) {
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
                .opacity(viewModel.sessionState == .completed ? 0.0 : 1.0)
                .animation(.easeInOut, value: viewModel.sessionState)
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
        
        if viewModel.sessionState == .completed {
            return minSize
        }
        
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
