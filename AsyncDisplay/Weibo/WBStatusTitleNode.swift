//
//  WBStatusTitleNode.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/5/12.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import AsyncDisplayKit

class WBStatusTitleNode: ASDisplayNode {
    let iconNode = ASNetworkImageNode()
    let countNode = ASTextNode()
    let lineNode = ASDisplayNode()

    convenience init(item: TitleModel) {
        self.init()

        iconNode.url = item.iconURL
        iconNode.style.width = ASDimensionMakeWithPoints(14)
        iconNode.style.height = ASDimensionMakeWithPoints(14)
        addSubnode(iconNode)

        countNode.attributedText = item.titleText
        addSubnode(countNode)

        lineNode.backgroundColor = kWBCellLineColor
        addSubnode(lineNode)

        subnodes.forEach { $0.isLayerBacked = true }
    }

    // With box model, you don't need to override this method, unless you want to add custom logic.
    override func layout() {
        super.layout()
        // Manually layout the divider.
        lineNode.frame = CGRect(x: 0.0, y: calculatedSize.height, width: screenW, height: onePix)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let mainStack = ASStackLayoutSpec(direction: .horizontal, spacing: 3, justifyContent: .start, alignItems: .center, children: [iconNode, countNode])

        // Adjust size
        mainStack.style.height = ASDimensionMakeWithPoints(kWBCellTitleHeight)

        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: kWBCellPadding, bottom: 0, right: 0), child: mainStack)
    }
}
