import SwiftUI
import SwiftData

struct StatisticsView: View {
    @Query(sort: \BreathingHistory.date, order: .reverse)
    private var history: [BreathingHistory]

    private var weeklyStats: [DailyStat] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)

        let grouped = Dictionary(grouping: history) { record in
            calendar.startOfDay(for: record.date)
        }

        return (0..<7).reversed().map { dayOffset in
            let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) ?? today
            let totalMinutes = grouped[date]?.reduce(0) { $0 + $1.durationInMinutes } ?? 0
            return DailyStat(date: date, totalMinutes: totalMinutes)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.blackGGS.ignoresSafeArea()

                if history.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            totalMinutesHeader
                            weeklyChart
                            sessionHistorySection
                        }
                        .padding(.bottom, 32)
                    }
                }
            }
            .navigationTitle("Practice Statistics")
            .preferredColorScheme(.dark)
        }
    }

    private var emptyState: some View {
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
    }

    private var totalMinutesHeader: some View {
        let totalMinutes = history.reduce(0) { $0 + $1.durationInMinutes }

        return VStack(spacing: 4) {
            Text("Total mindfulness minutes")
                .font(.sfRounded(size: 16, weight: .medium))
                .foregroundColor(.whiteGGS.opacity(0.6))
            Text("\(totalMinutes)")
                .font(.sfRounded(size: 48, weight: .bold))
                .foregroundColor(.whiteGGS)
        }
        .padding(.top, 16)
    }

    private var weeklyChart: some View {
        let maxMinutesInGraph = max(weeklyStats.map(\.totalMinutes).max() ?? 0, 1)

        return VStack(alignment: .leading, spacing: 12) {
            Text("Last 7 days")
                .font(.sfRounded(size: 14, weight: .semibold))
                .foregroundColor(.whiteGGS.opacity(0.6))
                .padding(.horizontal, 20)

            HStack(alignment: .bottom, spacing: 12) {
                ForEach(weeklyStats) { day in
                    VStack(spacing: 8) {
                        Text("\(day.totalMinutes) min")
                            .font(.sfRounded(size: 11, weight: .bold))
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                            .foregroundColor(.whiteGGS.opacity(day.totalMinutes > 0 ? 0.8 : 0.3))
                            .frame(maxWidth: .infinity)
                        
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
                            .frame(
                                height: max(4, CGFloat(day.totalMinutes) / CGFloat(maxMinutesInGraph) * 140)
                            )
                            .frame(width: 26)
                            .opacity(day.totalMinutes > 0 ? 1.0 : 0.25)

                        Text(day.dateLabel)
                            .font(.sfRounded(size: 10, weight: .medium))
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                            .foregroundColor(.whiteGGS.opacity(0.4))
                            .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 200)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 12)
            .padding(.vertical, 16)
            .background(Color.whiteGGS.opacity(0.03))
            .cornerRadius(20)
            .padding(.horizontal, 20)
        }
    }

    private var sessionHistorySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent sessions")
                .font(.sfRounded(size: 14, weight: .semibold))
                .foregroundColor(.whiteGGS.opacity(0.6))
                .padding(.horizontal, 20)

            VStack(spacing: 0) {
                ForEach(Array(history.prefix(20).enumerated()), id: \.element.persistentModelID) { index, record in
                    SessionHistoryRow(record: record)

                    if index < min(history.count, 20) - 1 {
                        Divider()
                            .background(Color.whiteGGS.opacity(0.08))
                            .padding(.leading, 20)
                    }
                }
            }
            .background(Color.whiteGGS.opacity(0.03))
            .cornerRadius(20)
            .padding(.horizontal, 20)
        }
    }
}

private struct SessionHistoryRow: View {
    let record: BreathingHistory

    private static let dateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        return formatter
    }()

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(record.practiceKind?.color ?? Color.blueGGS)
                .frame(width: 10, height: 10)

            VStack(alignment: .leading, spacing: 2) {
                if let kind = record.practiceKind {
                    Text(kind.title)
                        .font(.sfRounded(size: 16, weight: .semibold))
                        .foregroundColor(.whiteGGS)
                } else {
                    Text(record.practiceTitle)
                        .font(.sfRounded(size: 16, weight: .semibold))
                        .foregroundColor(.whiteGGS)
                }

                Text(Self.dateTimeFormatter.string(from: record.date))
                    .font(.sfRounded(size: 12, weight: .medium))
                    .foregroundColor(.whiteGGS.opacity(0.45))
            }

            Spacer()

            Text("\(record.durationInMinutes) min")
                .font(.sfRounded(size: 14, weight: .bold))
                .foregroundColor(.whiteGGS.opacity(0.8))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }
}
