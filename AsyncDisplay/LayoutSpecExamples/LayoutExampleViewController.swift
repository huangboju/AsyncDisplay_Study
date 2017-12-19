//
//  LayoutExampleViewController.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/25.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import AsyncDisplayKit

class LayoutExampleViewController: ASViewController<ASDisplayNode> {
    
    var customNode: LayoutExampleNode!
    
    init(layoutExample cls: LayoutExampleNode) {
        super.init(node: ASDisplayNode())

        title = "Layout Example"

        customNode = cls
        node.addSubnode(customNode)

        let needsOnlyYCentering = cls.isMember(of: HeaderWithRightAndLeftItems.self) ||
            cls.isMember(of: FlexibleSeparatorSurroundingContent.self)

        node.backgroundColor = needsOnlyYCentering ? UIColor.lightGray : UIColor.white

        node.layoutSpecBlock = { [unowned self] _, _ in
            let option: ASCenterLayoutSpecCenteringOptions = needsOnlyYCentering ? .Y : .XY
            return ASCenterLayoutSpec(centeringOptions: option, sizingOptions: .minimumXY, child: self.customNode)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
