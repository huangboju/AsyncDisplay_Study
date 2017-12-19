//
//  SupplementaryNode.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/19.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

let kInsets: CGFloat = 15.0

import AsyncDisplayKit

class SupplementaryNode: ASCellNode {
    var textNode: ASTextNode!
    
    init(text: String) {
        super.init()
        textNode = ASTextNode()
        textNode.attributedText = NSAttributedString(string: text, attributes: textAttributes)
        addSubnode(textNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let center = ASCenterLayoutSpec()
        center.centeringOptions = ASCenterLayoutSpecCenteringOptions.XY
        center.child = textNode
        let insets = UIEdgeInsets(top: kInsets, left: kInsets, bottom: kInsets, right: kInsets);
        return ASInsetLayoutSpec(insets: insets, child: center)
    }
    
    
    var textAttributes: [String: Any] {
        return [
            NSFontAttributeName: UIFont.systemFont(ofSize:18.0),
            NSForegroundColorAttributeName: UIColor.white,
        ]
    }
}
