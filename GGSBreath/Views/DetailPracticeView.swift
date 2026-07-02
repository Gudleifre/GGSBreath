import SwiftUI

struct DetailPracticeView: View {
    @State private var isPresentingSession = false
    let kind: PracticeKind
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [kind.color, Color.blackGGS]),
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
                    .accessibilityLabel("Close")
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Text(kind.title)
                    .font(.sfRounded(size: 36, weight: .bold))
                    .foregroundColor(.whiteGGS)
                    .padding(.top, 60)
                
                Spacer()
                
                HStack(spacing: 6) {
                    Text(kind.duration)
                    Text("•")
                    Text("\(kind.maxCycles) cycles")
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
                        Text("Purpose:")
                            .font(.sfRounded(size: 16, weight: .bold))
                            .foregroundColor(.whiteGGS)
                        Text(kind.purpose)
                            .font(.sfRounded(size: 16, weight: .regular))
                            .foregroundColor(.whiteGGS.opacity(0.8))
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Breathing technique:")
                            .font(.sfRounded(size: 16, weight: .bold))
                            .foregroundColor(.whiteGGS)
                        Text(kind.technique)
                            .font(.sfRounded(size: 16, weight: .regular))
                            .foregroundColor(.whiteGGS.opacity(0.8))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 40)
                
                Spacer()
                
                Button {
                    isPresentingSession = true
                } label: {
                    Text("Breathe")
                        .font(.sfRounded(size: 24, weight: .bold))
                        .foregroundColor(.whiteGGS)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(kind.color)
                        .clipShape(Capsule())
                        .padding(.horizontal, 74)
                }
                .padding(.bottom, 40)
                .fullScreenCover(isPresented: $isPresentingSession) {
                    SessionPracticeView(viewModel: PracticeViewModel(kind: kind))
                }
            }
        }
    }
}
