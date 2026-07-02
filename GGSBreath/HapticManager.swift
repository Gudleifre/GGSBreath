import UIKit

final class HapticManager {
    static let shared = HapticManager()
    
    private let lightGenerator = UIImpactFeedbackGenerator(style: .light)
    private let mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let heavyGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
    private init() {
        lightGenerator.prepare()
        mediumGenerator.prepare()
        heavyGenerator.prepare()
    }
    
    func triggerImpact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        switch style {
        case .light:
            lightGenerator.impactOccurred()
            lightGenerator.prepare()
        case .medium:
            mediumGenerator.impactOccurred()
            mediumGenerator.prepare()
        case .heavy:
            heavyGenerator.impactOccurred()
            heavyGenerator.prepare()
        default:
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.impactOccurred()
        }
    }
}
