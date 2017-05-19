//
//  WBStatusHelper.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/5/11.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

extension Bundle {
    class var WBBundle: Bundle {
        let path = Bundle(for: WBStatusTimelineViewController.self).path(forResource: "ResourceWeibo", ofType: "bundle")!
        return Bundle(path: path)!
    }
}

let WBStatusHelper = WBStatusSingleTon.shared

class WBStatusSingleTon {
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

    func addAttributes(_ attrs: [String : Any], range: NSRange? = nil) {
        addAttributes(attrs, range: range ?? NSRange(location: 0, length: length))
    }

    func addForegroundColor(_ color: UIColor, range: NSRange? = nil) {
        addAttributes([NSForegroundColorAttributeName: color], range: range)
    }

    func addFont(_ font: UIFont, range: NSRange? = nil) {
        addAttributes([NSFontAttributeName: font], range: range)
    }

    func addParagraphStyle(_ style: NSParagraphStyle, range: NSRange? = nil) {
        addAttributes([NSParagraphStyleAttributeName: style], range: range)
    }
    
//    func ParagraphStyleSet() {
//        self.enumerateAttribute(NSParagraphStyleAttributeName, in: rangeOfAll, options: []) { (value, subRange, stop) in
//            var style: NSMutableParagraphStyle
//            if let value = value {
//                var _value = value
//                if CFGetTypeID(_value as CFTypeRef!) == CTParagraphStyleGetTypeID() {
//                    _value = NSParagraphStyle(CTStyle: _value as! CTParagraphStyle)
//                }
//                if (value._attr_ == _attr_) { return }
//                if let pStyle = value as? NSMutableParagraphStyle {
//                    style = pStyle
//                } else {
//                    style = (value as AnyObject).mutableCopy
//                } 
//            } else {
//                
//                if NSParagraphStyle.default. _attr_ == _attr_) return;
//                style = NSParagraphStyle.default.mutableCopy;
//            }
//            style. _attr_ = _attr_; 
//            [self setParagraphStyle:style range:subRange]; 
//        }
//    }
}

extension NSRange {
    var isEmpty: Bool {
        return location == NSNotFound
    }
}
