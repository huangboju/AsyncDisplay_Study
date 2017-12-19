//
//  WBStatusCardNode.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/5/13.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import AsyncDisplayKit

class WBStatusCardNode: ASDisplayNode {
    let textNode = ASTextNode()
    var badgeNode: ASNetworkImageNode?
    var imageNode: ASNetworkImageNode?
    
    convenience init(item: CardModel) {
        self.init()

        borderWidth = onePix
        borderColor = UIColor(white: 0, alpha: 0.07).cgColor

        backgroundColor = kWBCellInnerViewColor

        textNode.attributedText = item.text
        textNode.maximumNumberOfLines = 3
        textNode.truncationAttributedText = NSAttributedString(forDescription: "…")
        addSubnode(textNode)

        if let badgeUrl = item.badgeUrl {
            badgeNode = ASNetworkImageNode()
            badgeNode?.url = badgeUrl
            let side = ASDimensionMake(25)
            badgeNode?.style.width = side
            badgeNode?.style.height = side
            addSubnode(badgeNode!)
        }

        if let picUrl = item.picUrl {
            badgeNode = ASNetworkImageNode()
            badgeNode?.url = picUrl
            badgeNode?.backgroundColor = ASDisplayNodeDefaultPlaceholderColor()
            let side = ASDimensionMake(70)
            badgeNode?.style.width = side
            badgeNode?.style.height = side
            addSubnode(badgeNode!)
        }
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        let relativeLayout = ASRelativeLayoutSpec(horizontalPosition: .start, verticalPosition: .start, sizingOption: [], child: badgeNode ?? ASLayoutSpec())

        textNode.style.maxWidth = ASDimensionMake(constrainedSize.max.width - 78)
        
        let mainStack = ASStackLayoutSpec(direction: .horizontal, spacing: 8, justifyContent: .start, alignItems: .center, children: [relativeLayout, textNode])

        mainStack.style.minWidth = ASDimensionMake(constrainedSize.max.width)

        return mainStack
    }
}
