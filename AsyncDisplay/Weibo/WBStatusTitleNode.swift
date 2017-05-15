//
//  WBStatusTitleNode.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/5/12.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class WBStatusTitleNode: ASDisplayNode {
    let iconNode = ASNetworkImageNode()
    let countNode = ASTextNode()
    
    init(item: TitleModel) {
        super.init()

        iconNode.url = item.iconURL
        iconNode.style.width = ASDimensionMakeWithPoints(14)
        iconNode.style.height = ASDimensionMakeWithPoints(14)
        addSubnode(iconNode)

        countNode.attributedText = item.titleText
        addSubnode(countNode)

        subnodes.forEach { $0.isLayerBacked = true }
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let mainStack = ASStackLayoutSpec(direction: .horizontal, spacing: 0, justifyContent: .start, alignItems: .center, children: [iconNode, countNode])

        // Adjust size
        mainStack.style.height = ASDimensionMakeWithPoints(kWBCellTitleHeight)
        return mainStack
    }
}
