import XCTest
@testable import GGSBreath

final class PracticeKindTests: XCTestCase {
    
    // MARK: - Pattern math
    func test_calmPattern_hasExpectedValues() {
        let pattern = PracticeKind.calm.pattern
        
        XCTAssertEqual(pattern.inhale, 4)
        XCTAssertEqual(pattern.holdIn, 7)
        XCTAssertEqual(pattern.exhale, 8)
        XCTAssertEqual(pattern.holdOut, 0)
        XCTAssertEqual(pattern.cycleDuration, 19)
        XCTAssertEqual(pattern.maxCycles, 16)
        XCTAssertEqual(pattern.totalSeconds, 304)
    }
    
    func test_energyPattern_hasExpectedValues() {
        let pattern = PracticeKind.energy.pattern
        
        XCTAssertEqual(pattern.cycleDuration, 3)
        XCTAssertEqual(pattern.maxCycles, 60)
        XCTAssertEqual(pattern.totalSeconds, 180)
    }
    
    func test_focusPattern_hasExpectedValues() {
        let pattern = PracticeKind.focus.pattern
        
        XCTAssertEqual(pattern.cycleDuration, 16)
        XCTAssertEqual(pattern.maxCycles, 15)
        XCTAssertEqual(pattern.totalSeconds, 240)
    }
    
    func test_sleepPattern_hasExpectedValues() {
        let pattern = PracticeKind.sleep.pattern
        
        XCTAssertEqual(pattern.cycleDuration, 12)
        XCTAssertEqual(pattern.maxCycles, 50) 
        XCTAssertEqual(pattern.totalSeconds, 600)
    }
    
    // MARK: - Derived properties
    func test_durationMinutes_matchesPatternTargetMinutes() {
        XCTAssertEqual(PracticeKind.calm.durationMinutes, 5)
        XCTAssertEqual(PracticeKind.energy.durationMinutes, 3)
        XCTAssertEqual(PracticeKind.focus.durationMinutes, 4)
        XCTAssertEqual(PracticeKind.sleep.durationMinutes, 10)
    }
    
    func test_maxCycles_matchesPatternMaxCycles() {
        for kind in PracticeKind.allCases {
            XCTAssertEqual(kind.maxCycles, kind.pattern.maxCycles, "Mismatch for \(kind)")
        }
    }
    
    // MARK: - Identifiable conformance
    func test_id_equalsRawValue() {
        for kind in PracticeKind.allCases {
            XCTAssertEqual(kind.id, kind.rawValue)
        }
    }
    
    func test_allCases_haveUniqueIds() {
        let ids = PracticeKind.allCases.map(\.id)
        XCTAssertEqual(ids.count, Set(ids).count, "PracticeKind ids must be unique")
    }
}
