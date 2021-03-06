//
//  OverviewTitleDescriptionCellNode.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/21.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import AsyncDisplayKit

class OverviewTitleDescriptionCellNode: ASCellNode {
    let titleNode = ASTextNode()
    let descriptionNode = ASTextNode()
    
    override init() {
        super.init()
        
        addSubnode(titleNode)
        addSubnode(descriptionNode)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let hasDescription = descriptionNode.attributedText!.length > 0

        let verticalStackLayoutSpec = ASStackLayoutSpec.vertical()
        verticalStackLayoutSpec.alignItems = .start
        verticalStackLayoutSpec.spacing = 5.0
        verticalStackLayoutSpec.children = hasDescription ? [titleNode, descriptionNode] : [titleNode]

        return ASInsetLayoutSpec(insets: UIEdgeInsets.init(top: 10, left: 16, bottom: 10, right: 10), child: verticalStackLayoutSpec)
    }
}
