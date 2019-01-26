//
//  OverviewCellNode.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/25.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import AsyncDisplayKit

class OverviewCellNode: ASCellNode {
    private var titleNode: ASTextNode!
    private var descriptionNode: ASTextNode!

    var layoutExampleClass: LayoutExampleNode.Type!
    
    init(cls: LayoutExampleNode.Type) {
        super.init()
        automaticallyManagesSubnodes = true

        layoutExampleClass = cls
        
        titleNode = ASTextNode()

        titleNode.attributedText = NSAttributedString(string: layoutExampleClass.title ?? "", fontSize: 16, color: UIColor.black)

        descriptionNode = ASTextNode()
        descriptionNode.attributedText = NSAttributedString(string: layoutExampleClass.descriptionTitle ?? "", fontSize: 12, color: UIColor.lightGray)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let verticalStackSpec = ASStackLayoutSpec.vertical()
        verticalStackSpec.alignItems = .start
        verticalStackSpec.spacing = 5.0
        verticalStackSpec.children = [titleNode, descriptionNode]

        return ASInsetLayoutSpec(insets: UIEdgeInsets.init(top: 10, left: 16, bottom: 10, right: 10), child: verticalStackSpec)
    }
}
