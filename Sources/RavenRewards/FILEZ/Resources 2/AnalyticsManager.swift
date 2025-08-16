//
//  AnalyticsManager.swift
//  Instagram
//
//  Created by Afraz Siddiqui on 3/20/21.
//

import Foundation
#if os(Android)
    import SkipFirebaseAnalytics
#else
    import FirebaseAnalytics
#endif

@MainActor final class AnalyticsManager {
    static let shared = AnalyticsManager()

    private init() {}

    enum FeedInteraction: String {
        case like
        case comment
        case share
        case reported
        case doubleTapToLike
    }

    func logFeedInteraction(_ type: FeedInteraction) {
        Analytics.logEvent(
            "feedback_interaction",
            parameters: [
                "type":type.rawValue.lowercased()
            ]
        )
    }
}
