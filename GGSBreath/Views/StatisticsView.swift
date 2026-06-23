import SwiftUI

struct StatisticsView: View {
    var body: some View {
        ZStack {
            Color.blackGGS.ignoresSafeArea()
            
            VStack(spacing: 16) {
                Image(systemName: "chart.bar.xaxis")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(.blueGGS) 
                
                Text("Статистика практик")
                    .font(.sfRounded(size: 24, weight: .bold))
                    .foregroundColor(.whiteGGS)
                
                Text("Здесь будет история твоих сессий и минут осознанности.")
                    .font(.sfRounded(size: 14, weight: .medium))
                    .foregroundColor(.whiteGGS.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
        }
    }
}
