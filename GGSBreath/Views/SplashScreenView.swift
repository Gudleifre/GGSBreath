import SwiftUI

struct SplashScreenView: View {
    @State private var isAnimating: Bool = false
    
    var onFinished: () -> Void
    
    var body: some View {
        ZStack {
            Color.blackGGS.ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                HStack(spacing: 12) {
                    Text("G.G.S")
                        .font(.sfRounded(size: 40, weight: .bold))
                        .foregroundColor(.whiteGGS)
                        .opacity(isAnimating ? 1.0 : 0.0)
                    
                    ZStack(alignment: .bottom) {
                        Capsule()
                            .fill(Color.whiteGGS.opacity(0.15))
                            .frame(width: 6, height: 32)
                            .opacity(isAnimating ? 1.0 : 0.0)
                        
                        Capsule()
                            .fill(Color.blueGGS)
                            .frame(width: 6, height: isAnimating ? 32 : 0)
                    }
                    
                    Text("Breath")
                        .font(.sfRounded(size: 40, weight: .bold))
                        .foregroundColor(.whiteGGS)
                        .opacity(isAnimating ? 1.0 : 0.0)
                }
                
                Text("Ничего лишнего, только дыхание")
                    .font(.sfRounded(size: 16, weight: .medium))
                    .foregroundColor(.whiteGGS.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .offset(y: isAnimating ? 0 : 8)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5)) {
                isAnimating = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.9) {
                onFinished()
            }
        }
    }
}
