//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//  Created by KingCQ on 16/8/29.
//

extension Date {
    var timeAgo: String {
        if minutesAgo() < 0.5 {
            return "刚刚"
        } else if minutesAgo() <= 2 {
            return "1分钟"
        } else if hoursAgo() < 1 {
            return Int(round(minutesAgo() - 0.5)).description + "分钟前"
        } else if daysAgo() < 1 {
            return Int(round(hoursAgo() - 0.5)).description + "小时前"
        } else if daysAgo() < 2 {
            return "昨天" + formattedDateWith(format: "HH:mm")
        } else if month < 1 {
            return formattedDateWith(format: "dd HH:mm")
        } else if yearsAgo() < 1 {
            return formattedDateWith(format: "MM-dd HH:mm")
        } else {
            return formattedDateWith(format: "yy-MM-dd")
        }
    }

    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }

    enum TimeType: TimeInterval {
        case minute = 60
        case hour = 3600
        case day = 86400
    }

    func minutesAgo() -> TimeInterval {
        return timeEarlierThan(date: Date(), with: .minute)
    }

    func hoursAgo() -> TimeInterval {
        return timeEarlierThan(date: Date(), with: .hour)
    }

    func daysAgo() -> TimeInterval {
        return timeEarlierThan(date: Date(), with: .day)
    }

    func yearsAgo() -> TimeInterval {
        return yearsEarlierThan(date: Date())
    }

    func timeEarlierThan(date: Date, with type: TimeType) -> TimeInterval {
        return abs(min(timeFrom(date: date, timeInterval: type.rawValue), 0))
    }

    func yearsEarlierThan(date: Date) -> TimeInterval {
        let falg = year % 4 == 0 && year % 100 != 0 || year % 400 == 0
        return abs(min(timeFrom(date: date, timeInterval: falg ? 31622400 : 31536000), 0))
    }

    func timeFrom(date: Date, timeInterval: TimeInterval) -> TimeInterval {
        return timeIntervalSince(date) / timeInterval
    }

    func formattedDateWith(format: String) -> String {
        return formattedDateWith(format: format, timeZone: .current, locale: .autoupdatingCurrent)
    }

    func formattedDateWith(format: String, timeZone: TimeZone, locale: Locale) -> String {
        let formatter = WBStatusHelper.dateFormatter
        formatter.dateFormat = format
        formatter.timeZone = timeZone
        formatter.locale = locale
        return formatter.string(from: self)
    }
}
