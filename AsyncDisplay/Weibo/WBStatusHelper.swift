//
//  WBStatusHelper.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/5/11.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

extension Array {
    func split(by count: Int) -> [[Element]] {
        var result: [[Element]] = []
        for (i, item) in self.enumerated() {
            if result.isEmpty || i % count == 0 {
                result.append([item])
            } else {
                result[i / count].append(item)
            }
        }
        return result
    }
}

extension Bundle {
    class var WBBundle: Bundle {
        let path = Bundle(for: ViewController.self).path(forResource: "ResourceWeibo", ofType: "bundle")!
        return Bundle(path: path)!
    }
}

let WBStatusHelper = WBStatusSingleTon.shared

class WBStatusSingleTon {
    private var _dateFormatter: DateFormatter?
    
    var dateFormatter: DateFormatter {
        if _dateFormatter == nil {
            _dateFormatter = DateFormatter()
        }
        return _dateFormatter!
    }

    static let shared = WBStatusSingleTon()
    
    private var _hrefRegex: NSRegularExpression?
    var hrefRegex: NSRegularExpression? {
        if _hrefRegex == nil {
            _hrefRegex = try? NSRegularExpression(pattern: "(?<=href=\").+(?=\" )", options: [])
        }
        return _hrefRegex
    }

    private var _textRegex: NSRegularExpression?
    var textRegex: NSRegularExpression? {
        if _textRegex == nil {
            _textRegex = try? NSRegularExpression(pattern: "(?<=>).+(?=<)", options: [])
        }
        return _textRegex
    }
    
    
    private var _regexAt: NSRegularExpression?
    var regexAt: NSRegularExpression? {
        if _regexAt == nil {
            // 微博的 At 只允许 英文数字下划线连字符，和 unicode 4E00~9FA5 范围内的中文字符，这里保持和微博一致。。
            // 目前中文字符范围比这个大
            _regexAt = try? NSRegularExpression(pattern: "@[-_a-zA-Z0-9\\u4E00-\\u9FA5]+", options: [])
        }
        return _regexAt
    }
    

    private var _regexEmoticon: NSRegularExpression?
    var regexEmoticon: NSRegularExpression? {
        if _regexEmoticon == nil {
            _regexEmoticon = try? NSRegularExpression(pattern: "\\[[^ \\[\\]]+?\\]", options: [])
        }
        return _regexEmoticon
    }

    func image(with name: String) -> UIImage? {
        return UIImage(named: name, in: Bundle.WBBundle, compatibleWith: nil)
    }

    func formatUrl(with urlStr: String?) -> String {
        var link = urlStr ?? ""
        if link.hasSuffix(".png") {
            // add "_default"
            if !link.hasSuffix("_default.png") {
                let sub = link.substring(to: link.length - 4)
                link = sub + "_default.png"
            }
        } else {
            // replace "_y.png" with "_os7.png"
            let range = link.nsrange(of: "_y.png?version")
            if !range.isEmpty {
                link = (link as NSString).replacingCharacters(in: NSRange(location: range.location + 1, length: 1), with: "os7")
            }
        }
        return link
    }
}

extension UIColor {
    /** 16进制颜色 */
    convenience init(hex: Int, alpha: CGFloat = 1) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255
        let green = CGFloat((hex & 0xFF00) >> 8) / 255
        let blue = CGFloat(hex & 0xFF) / 255
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension UIFont {
    /// 12
    class var smallSystemFont: UIFont {
        return UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
    }

    /// 14
    class var systemFont: UIFont {
        return UIFont.systemFont(ofSize: UIFont.systemFontSize)
    }

    /// 17
    class var labelFont: UIFont {
        return UIFont.systemFont(ofSize: UIFont.labelFontSize)
    }

    /// 18
    class var buttonFont: UIFont {
        return UIFont.systemFont(ofSize: UIFont.buttonFontSize)
    }
}

extension NSAttributedString {
    var isEmpty: Bool {
        return length == 0
    }
}

extension NSMutableAttributedString {
    public var rangeOfAll: NSRange {
        return NSRange(location: 0, length: length)
    }

    func append(str: String) {
        append(NSAttributedString(string: str))
    }

    func addAttributes(_ attrs: [NSAttributedString.Key : Any], range: NSRange? = nil) {
        addAttributes(attrs, range: range ?? NSRange(location: 0, length: length))
    }

    func addForegroundColor(_ color: UIColor, range: NSRange? = nil) {
        addAttributes([NSAttributedString.Key.foregroundColor: color], range: range ?? NSRange(location: 0, length: length))
    }

    func addFont(_ font: UIFont, range: NSRange? = nil) {
        addAttributes([NSAttributedString.Key.font: font], range: range ?? NSRange(location: 0, length: length))
    }

    func addParagraphStyle(_ style: NSParagraphStyle, range: NSRange? = nil) {
        addAttributes([NSAttributedString.Key.paragraphStyle: style], range: range ?? NSRange(location: 0, length: length))
    }

    func addLink(_ url: URL, range: NSRange? = nil) {
        addAttributes([kLinkAttributeName: url], range: range ?? NSRange(location: 0, length: length))
    }
}

extension NSRange {
    var isEmpty: Bool {
        return location == NSNotFound
    }
}

struct RouterKeys {

}

struct EventName {
    static let toolBarEvent = "toolBarEvent"
}

extension UIResponder {

    @objc func router(with eventName: String, userInfo: [String: Any]) {
        if let next = next {
            next.router(with: eventName, userInfo: userInfo)
        }
    }
}
