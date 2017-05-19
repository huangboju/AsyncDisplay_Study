//
//  NSParagraphStyle+Extension.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/5/17.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

extension CTLineBreakMode {
    var toNSLineBreakMode: NSLineBreakMode {
        switch self {
        case .byWordWrapping:
            return .byCharWrapping
        case .byCharWrapping:
            return .byCharWrapping
        case .byClipping:
            return .byClipping
        case .byTruncatingHead:
            return .byTruncatingHead
        case .byTruncatingTail:
            return .byTruncatingTail
        case .byTruncatingMiddle:
            return .byTruncatingMiddle
        }
    }
}

extension CTWritingDirection {
    var toNSWritingDirection: NSWritingDirection {
        switch self {
        case .natural:
            return .natural
        case .leftToRight:
            return .leftToRight
        case .rightToLeft:
            return .rightToLeft
        }
    }
}

extension NSParagraphStyle {

    convenience init(CTStyle: CTParagraphStyle) {
        
        let style = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        
        var lineSpacing: CGFloat = 0
        if (CTParagraphStyleGetValueForSpecifier(CTStyle, .lineSpacingAdjustment, MemoryLayout<CGFloat>.size, &lineSpacing)) {
            style?.lineSpacing = lineSpacing
        }
        
        let CGFloatBufferSize = MemoryLayout<CGFloat>.size
        
        var _paragraphSpacing: CGFloat = 0
        if CTParagraphStyleGetValueForSpecifier(CTStyle, .paragraphSpacing, CGFloatBufferSize, &_paragraphSpacing) {
            style?.paragraphSpacing = _paragraphSpacing
        }

        var _alignment: CTTextAlignment = .left
        if CTParagraphStyleGetValueForSpecifier(CTStyle, .alignment, MemoryLayout<CTTextAlignment>.size, &_alignment) {
            style?.alignment = NSTextAlignmentFromCTTextAlignment(_alignment)
        }

        var _firstLineHeadIndent: CGFloat = 0
        if (CTParagraphStyleGetValueForSpecifier(CTStyle, .firstLineHeadIndent, CGFloatBufferSize, &_firstLineHeadIndent)) {
            style?.firstLineHeadIndent = _firstLineHeadIndent
        }

        var _headIndent: CGFloat = 0
        if CTParagraphStyleGetValueForSpecifier(CTStyle, .headIndent, CGFloatBufferSize, &_headIndent) {
            style?.headIndent = _headIndent
        }
        
        var _tailIndent: CGFloat = 0
        if CTParagraphStyleGetValueForSpecifier(CTStyle, .tailIndent, CGFloatBufferSize, &_tailIndent) {
            style?.tailIndent = _tailIndent
        }
        
        var _lineBreakMode: CTLineBreakMode = .byWordWrapping
        if (CTParagraphStyleGetValueForSpecifier(CTStyle, .lineBreakMode, MemoryLayout<CTLineBreakMode>.size, &_lineBreakMode)) {
            style?.lineBreakMode = _lineBreakMode.toNSLineBreakMode
        }

        var _minimumLineHeight: CGFloat = 0
        if (CTParagraphStyleGetValueForSpecifier(CTStyle, .minimumLineHeight, CGFloatBufferSize, &_minimumLineHeight)) {
            style?.minimumLineHeight = _minimumLineHeight
        }

        var _maximumLineHeight: CGFloat = 0
        if CTParagraphStyleGetValueForSpecifier(CTStyle, .maximumLineHeight, CGFloatBufferSize, &_maximumLineHeight) {
            style?.maximumLineHeight = _maximumLineHeight
        }

        var _baseWritingDirection: CTWritingDirection = .natural
        if CTParagraphStyleGetValueForSpecifier(CTStyle, .baseWritingDirection, MemoryLayout<CTWritingDirection>.size, &_baseWritingDirection) {
            style?.baseWritingDirection = _baseWritingDirection.toNSWritingDirection
        }

        var _lineHeightMultiple: CGFloat = 0
        if CTParagraphStyleGetValueForSpecifier(CTStyle, .lineHeightMultiple, CGFloatBufferSize, &_lineHeightMultiple) {
            style?.lineHeightMultiple = _lineHeightMultiple
        }

        var _paragraphSpacingBefore: CGFloat = 0
        if CTParagraphStyleGetValueForSpecifier(CTStyle, .paragraphSpacingBefore, CGFloatBufferSize, &_paragraphSpacingBefore) {
            style?.paragraphSpacingBefore = _paragraphSpacingBefore
        }
        
//        var _tabStops: CFArray
//        if CTParagraphStyleGetValueForSpecifier(CTStyle, .tabStops, MemoryLayout<CFArray>.size, &_tabStops) {
//            var tabs: [NSTextTab] = []
//
////            (_tabStops as  NSArray).forEach({ (obj) in
////                let ctTab = obj as! CTTextTab
////                let tab = NSTextTab(textAlignment: CTTextTabGetAlignment(ctTab), location: CTTextTabGetLocation(ctTab), options: CTTextTabGetOptions(ctTab))
////
////                tabs.append(tab)
////            })
////
////            if !tabs.isEmpty {
////                style?.tabStops = tabs
////            }
//        }
//
//        var _defaultTabInterval: CGFloat
//        if CTParagraphStyleGetValueForSpecifier(CTStyle, .defaultTabInterval, CGFloatBufferSize, &_defaultTabInterval) {
//            style?.defaultTabInterval = _defaultTabInterval
//        }

        self.init()
    }
}
