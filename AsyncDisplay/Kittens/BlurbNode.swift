//
//  BlurbNode.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/25.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

//private let kLinkAttributeName = "PlaceKittenNodeLinkAttributeName"
private let kTextPadding: CGFloat = 10.0

import AsyncDisplayKit

class BlurbNode: ASCellNode, ASTextNodeDelegate {
    var textNode: ASTextNode!

    override init() {
        super.init()
        // create a text node
        textNode = ASTextNode()

        // configure the node to support tappable links
        textNode.delegate = self
        textNode.isUserInteractionEnabled = true
        textNode.linkAttributeNames = [kLinkAttributeName.rawValue]

        // generate an attributed string using the custom link attribute specified above
        let blurb = "kittens courtesy placekitten.com 😸"

        let string = NSMutableAttributedString(string: blurb)
        string.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "HelveticaNeue-Light", size: 16)!, range: NSMakeRange(0, blurb.length))
        string.addAttributes([
            kLinkAttributeName: URL(string: "http://placekitten.com/")!,
            .foregroundColor: UIColor.gray,
            .underlineStyle: NSUnderlineStyle.styleSingle.rawValue | NSUnderlineStyle.patternDot.rawValue
            ], range: (blurb as NSString).range(of: "placekitten.com"))

        textNode.attributedText = string

        // add it as a subnode, and we're done
        addSubnode(textNode)
    }
    
    override func didLoad() {
        // enable highlighting now that self.layer has loaded -- see ASHighlightOverlayLayer.h
        layer.as_allowsHighlightDrawing = true
        super.didLoad()
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let centerSpec = ASCenterLayoutSpec()
        centerSpec.centeringOptions = .X
        centerSpec.sizingOptions = .minimumY
        centerSpec.child = textNode

        let padding = UIEdgeInsetsMake(kTextPadding, kTextPadding, kTextPadding, kTextPadding)
        return ASInsetLayoutSpec(insets: padding, child: centerSpec)
    }
    
    // MARK: - ASTextNodeDelegate methods.
    
    
    func textNode(_ textNode: ASTextNode, shouldHighlightLinkAttribute attribute: String, value: Any, at point: CGPoint) -> Bool {
    // opt into link highlighting -- tap and hold the link to try it!  must enable highlighting on a layer, see -didLoad
        return true
    }

    func textNode(_ textNode: ASTextNode, tappedLinkAttribute attribute: String, value: Any, at point: CGPoint, textRange: NSRange) {
    // the node tapped a link, open it
        guard let url = value as? URL else {
            return
        }
        UIApplication.shared.openURL(url)
    }
}

extension String {
    
    var encode: String {
        let unreservedChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
        let unreservedCharset = CharacterSet(charactersIn: unreservedChars)
        
        return addingPercentEncoding(withAllowedCharacters: unreservedCharset) ?? self
    }
    
    var decode: String {
        return removingPercentEncoding ?? self
    }

    public var rangeOfAll: NSRange {
        return NSRange(location: 0, length: length)
    }

    /**
     字符串长度
     */
    public var length: Int {
        return count
    }
    
    /**
     是否包含某个字符串
     
     - parameter s: 字符串
     
     - returns: bool
     */
    func has(_ s: String) -> Bool {
        return range(of: s) != nil
    }
    
    /**
     分割字符
     
     - parameter s: 字符
     
     - returns: 数组
     */
    func split(_ s: String) -> [String] {
        if s.isEmpty {
            return []
        }
        return components(separatedBy: s)
    }
    
    /**
     去掉左右空格
     
     - returns: string
     */
    func trim() -> String {
        return trimmingCharacters(in: CharacterSet.whitespaces)
    }

    func replace(_ old: String, new: String) -> String {
        return replacingOccurrences(of: old, with: new, options: NSString.CompareOptions.numeric, range: nil)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func index(from: Int) -> Index {
        return index(startIndex, offsetBy: from)
    }

    func substring(fromIndex: Int, toIndex: Int) -> String {
        let range = NSRange(location: fromIndex, length: toIndex - fromIndex)
        return substr(with: range)
    }

    func substr(with range: NSRange) -> String {
        let start = index(startIndex, offsetBy: range.location)
        let end = index(endIndex, offsetBy: range.location + range.length - count)
        return String(self[start ..< end])
    }

    func nsrange(of str: String) -> NSRange {
        return (self as NSString).range(of: str)
    }

    var formatToTime: String {
        // https://iosdevcenters.blogspot.com/2016/03/nsdateformatter-in-swift.html

        let formatter = WBStatusHelper.dateFormatter
        formatter.dateFormat = "E MMM MM HH:mm:ss Z yyyy"
        let date = formatter.date(from: self) ?? Date()
        return date.timeAgo
    }
}
