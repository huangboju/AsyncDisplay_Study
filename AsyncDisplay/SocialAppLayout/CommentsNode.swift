//
//  CommentsNode.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/26.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import AsyncDisplayKit

class CommentsNode: ASControlNode {
    let iconNode = ASImageNode()
    let countNode = ASTextNode()
    var commentsCount = 0

    init(comentsCount: Int) {
        super.init()
        commentsCount = comentsCount
        
        iconNode.image = UIImage(named: "icon_comment")
        addSubnode(iconNode)

        if commentsCount > 0 {
            countNode.attributedText = NSAttributedString(string: "\(commentsCount)", attributes: TextStyles.cellControlStyle)
        }
        addSubnode(countNode)

        // make it tappable easily
        hitTestSlop = UIEdgeInsets.init(top: -10, left: -10, bottom: -10, right: -10)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let mainStack = ASStackLayoutSpec(direction: .horizontal, spacing: 6, justifyContent: .start, alignItems: .center, children: [iconNode, countNode])

        // Adjust size
        mainStack.style.minWidth = ASDimensionMakeWithPoints(60.0)
        mainStack.style.maxHeight = ASDimensionMakeWithPoints(40.0)
        
        return mainStack
    }
}
