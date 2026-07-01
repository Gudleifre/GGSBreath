import SwiftUI
import SwiftData

struct StatisticsView: View {
    @Query(sort: \BreathingHistory.date, order: .reverse)
    
    private var history: [BreathingHistory]
    
    private var weeklyStats: [DailyStat] {
        let calendar = Calendar.current
        
        let grouped = Dictionary(grouping: history) { item in
            calendar.startOfDay(for: item.date)
        }
        
        let stats = grouped.map { (date, items) -> DailyStat in
            let totalMins = items.reduce(0) { $0 + $1.durationInMinutes }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM"
            formatter.locale = Locale.current
            let dateStr = formatter.string(from: date)
            
            return DailyStat(dateString: dateStr, totalMinutes: totalMins)
        }
        
        let sortedKeys = grouped.keys.sorted()
        let last7Keys = sortedKeys.suffix(7)
        
        return last7Keys.compactMap { date in
            stats.first { $0.dateString == {
                let f = DateFormatter()
                f.dateFormat = "d MMM"
                return f.string(from: date)
            }() }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.blackGGS.ignoresSafeArea()
                
                if history.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "chart.bar.xaxis")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(.blueGGS)
                        
                        Text("Practice Statistics")
                            .font(.sfRounded(size: 24, weight: .bold))
                            .foregroundColor(.whiteGGS)
                        
                        Text("Your session history and mindfulness minutes will appear here.")
                            .font(.sfRounded(size: 14, weight: .medium))
                            .foregroundColor(.whiteGGS.opacity(0.5))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                } else {
                    VStack(spacing: 20) {
                        let totalMinutes = history.reduce(0) { $0 + $1.durationInMinutes }
                        
                        VStack(spacing: 4) {
                            Text("Total mindfulness minutes")
                                .font(.sfRounded(size: 16, weight: .medium))
                                .foregroundColor(.whiteGGS.opacity(0.6))
                            Text("\(totalMinutes)")
                                .font(.sfRounded(size: 48, weight: .bold))
                                .foregroundColor(.whiteGGS)
                        }
                        .padding(.top, 30)
                        
                        let maxMinutesInGraph = weeklyStats.map { $0.totalMinutes }.max() ?? 1
                        
                        VStack(spacing: 12) {
                            HStack(alignment: .bottom, spacing: 18) {
                                ForEach(weeklyStats) { day in
                                    VStack(spacing: 8) {
                                        
                                        Text("\(day.totalMinutes) min")
                                            .font(.sfRounded(size: 12, weight: .bold))
                                            .foregroundColor(.whiteGGS.opacity(0.8))
                                        
                                        Capsule()
                                            .fill(
                                                LinearGradient(
                                                    colors: [
                                                        Color.blueGGS,
                                                        Color.blueGGS.opacity(0.25)
                                                    ],
                                                    startPoint: .top,
                                                    endPoint: .bottom
                                                )
                                            )
                                            .frame(height: CGFloat(day.totalMinutes) / CGFloat(maxMinutesInGraph) * 140)
                                            .frame(width: 28)
                                        
                                        Text(day.dateString)
                                            .font(.sfRounded(size: 11, weight: .medium))
                                            .foregroundColor(.whiteGGS.opacity(0.4))
                                    }
                                }
                            }
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                            .background(Color.whiteGGS.opacity(0.03))
                            .cornerRadius(20)
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer()
                    }
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}
