//
//  LikesNode.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/26.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import AsyncDisplayKit

class LikesNode: ASControlNode {
    let iconNode = ASImageNode()
    let countNode = ASTextNode()
    var likesCount: Int = 0
    var liked = false
    
    init(likesCount: Int) {
        super.init()

        self.likesCount = likesCount
        liked = (likesCount > 0) ? LikesNode.getYesOrNo : false

        iconNode.image =  UIImage(named: liked ? "icon_liked" : "icon_like")
        addSubnode(iconNode)

        if likesCount > 0 {
            let attributes = liked ? TextStyles.cellControlColoredStyle : TextStyles.cellControlStyle
            countNode.attributedText = NSAttributedString(string: "\(likesCount)", attributes: attributes)
            
        }
        addSubnode(countNode)

        // make it tappable easily
        hitTestSlop = UIEdgeInsetsMake(-10, -10, -10, -10)
    }

    static var getYesOrNo: Bool {
        let tmp = (arc4random() % 30) + 1
        return tmp % 5 == 0
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        let mainStack =
            ASStackLayoutSpec(direction: .horizontal, spacing: 6, justifyContent: .start, alignItems: .center, children: [iconNode, countNode])

        mainStack.style.minWidth = ASDimensionMakeWithPoints(60.0)
        mainStack.style.maxHeight = ASDimensionMakeWithPoints(40.0)
        
        return mainStack
    }
}
