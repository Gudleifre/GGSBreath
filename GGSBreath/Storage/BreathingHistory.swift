import Foundation
import SwiftData
import SwiftUI

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
}
