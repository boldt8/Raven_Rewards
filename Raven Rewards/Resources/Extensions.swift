//
//  Extensions.swift
//  Instagram
//
//  Created by Afraz Siddiqui on 3/21/21.
//

import Foundation
import UIKit


extension UIView {
    var top: CGFloat {
        frame.origin.y
    }

    var bottom: CGFloat {
        frame.origin.y+height
    }

    var left: CGFloat {
        frame.origin.x
    }

    var right: CGFloat {
        frame.origin.x+width
    }

    var width: CGFloat {
        frame.size.width
    }

    var height: CGFloat {
        frame.size.height
    }
}

extension Decodable {
    /// Create model with dictionary
    /// - Parameter dictionary: Firestore data
    init?(with dictionary: [String: Any]) {
        guard let data = try? JSONSerialization.data(
            withJSONObject: dictionary,
            options: .prettyPrinted
        ) else {
            return nil
        }
        guard let result = try? JSONDecoder().decode(
            Self.self,
            from: data
        ) else {
            return nil
        }
        self = result
    }
}

extension Encodable {
    /// Convert model to dictionary
    /// - Returns: Optional dictionary representation
    func asDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        let json = try? JSONSerialization.jsonObject(
            with: data,
            options: .allowFragments
        ) as? [String: Any]
        return json
    }
}

extension DateFormatter {
    /// Static date formatter
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

extension String {
    /// Convert string from Date
    /// - Parameter date: Source date
    /// - Returns: String representation
    static func date(from date: Date) -> String? {
        let formatter = DateFormatter.formatter
        let string = formatter.string(from: date)
        return string
    }
}

extension Notification.Name {
    /// Notification to inform of new post
    static let didPostNotification = Notification.Name("didPostNotification")
}

extension Double {
    func truncate(places : Int)-> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}

extension Date {
    func convertToTimeZone(initTimeZone: TimeZone, timeZone: TimeZone) -> Date {
         let delta = TimeInterval(timeZone.secondsFromGMT(for: self) - initTimeZone.secondsFromGMT(for: self))
         return addingTimeInterval(delta)
    }
}

