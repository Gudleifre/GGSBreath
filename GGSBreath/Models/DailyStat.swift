import Foundation

struct DailyStat: Identifiable {
    let date: Date
    let totalMinutes: Int
    
    var id: Date { date }
    
    var dateLabel: String {
        Self.dayFormatter.string(from: date)
    }
    
    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        formatter.locale = Locale.current
        return formatter
    }()
}
