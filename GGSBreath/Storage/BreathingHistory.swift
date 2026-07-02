import Foundation
import SwiftData

@Model
final class BreathingHistory {
    var date: Date
    var durationInMinutes: Int
    var practiceTitle: String
    
    init(date: Date = .now, durationInMinutes: Int, practiceTitle: String) {
        self.date = date
        self.durationInMinutes = durationInMinutes
        self.practiceTitle = practiceTitle
    }
    
    var practiceKind: PracticeKind? {
        PracticeKind(rawValue: practiceTitle)
    }
}
