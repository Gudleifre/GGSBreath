import XCTest
@testable import GGSBreath

final class BreathingHistoryTests: XCTestCase {
    
    // MARK: - Init
    func test_init_setsProvidedValues() {
        let fixedDate = Date(timeIntervalSince1970: 1_700_000_000)
        let record = BreathingHistory(
            date: fixedDate,
            durationInMinutes: 5,
            practiceTitle: PracticeKind.calm.rawValue
        )
        
        XCTAssertEqual(record.date, fixedDate)
        XCTAssertEqual(record.durationInMinutes, 5)
        XCTAssertEqual(record.practiceTitle, PracticeKind.calm.rawValue)
    }
    
    func test_init_defaultDate_isApproximatelyNow() {
        let record = BreathingHistory(durationInMinutes: 3, practiceTitle: PracticeKind.energy.rawValue)
        
        let diff = abs(record.date.timeIntervalSinceNow)
        XCTAssertLessThan(diff, 1.0)
    }
    
    // MARK: - practiceKind computed property
    func test_practiceKind_returnsCorrectEnum_forEachValidTitle() {
        for kind in PracticeKind.allCases {
            let record = BreathingHistory(durationInMinutes: kind.durationMinutes, practiceTitle: kind.rawValue)
            XCTAssertEqual(record.practiceKind, kind)
        }
    }
    
    func test_practiceKind_returnsNil_forUnknownTitle() {
        let record = BreathingHistory(durationInMinutes: 5, practiceTitle: "some_deleted_or_renamed_kind")
        XCTAssertNil(record.practiceKind)
    }
}
