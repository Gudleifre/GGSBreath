import Foundation

struct DailyStat: Identifiable {
    let id = UUID()
    let dateString: String
    let totalMinutes: Int
}
