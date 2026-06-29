import SwiftUI

struct DetailPracticeView: View {
    @State private var isPresentingSession = false
    let practice: BreathingPractice
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [practice.color, Color.blackGGS]),
                startPoint: .top,
                endPoint: .center
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.whiteGGS)
                            .padding(.vertical, 10)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Text(practice.title)
                    .font(.sfRounded(size: 36, weight: .bold))
                    .foregroundColor(.whiteGGS)
                    .padding(.top, 60)
                
                Spacer()
                
                HStack(spacing: 6) {
                    Text(practice.duration)
                    Text("•")
                    Text(practice.cycles)
                }
                .font(.sfRounded(size: 16, weight: .medium))
                .foregroundColor(.whiteGGS)
                
                Rectangle()
                    .fill(Color.whiteGGS.opacity(0.2))
                    .frame(height: 1)
                    .padding(.horizontal, 40)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Смысл:")
                            .font(.sfRounded(size: 16, weight: .bold))
                            .foregroundColor(.whiteGGS)
                        Text(practice.purpose)
                            .font(.sfRounded(size: 16, weight: .regular))
                            .foregroundColor(.whiteGGS.opacity(0.8))
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Техника дыхания:")
                            .font(.sfRounded(size: 16, weight: .bold))
                            .foregroundColor(.whiteGGS)
                        Text(practice.technique)
                            .font(.sfRounded(size: 16, weight: .regular))
                            .foregroundColor(.whiteGGS.opacity(0.8))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 40)
                
                Spacer()
                
                Button(action: {
                    isPresentingSession = true
                }) {
                    Text("Дышать")
                        .font(.sfRounded(size: 24, weight: .bold))
                        .foregroundColor(.whiteGGS)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(practice.color)
                        .clipShape(Capsule())
                        .padding(.horizontal, 74)
                }
                .padding(.bottom, 40)
                .fullScreenCover(isPresented: $isPresentingSession) {
                    SessionPracticeView(viewModel: PracticeViewModel(practice: practice))
                }
            }
        }
    }
}
