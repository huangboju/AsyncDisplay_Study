//
//  OverviewDisplayNodeWithSizeBlock.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/21.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import AsyncDisplayKit

protocol ASLayoutSpecListEntry {
    var entryTitle: String? { set get }
    var entryDescription: String? { set get }
}

typealias OverviewDisplayNodeSizeThatFitsBlock = (ASSizeRange) -> ASLayoutSpec

class OverviewDisplayNodeWithSizeBlock: ASDisplayNode, ASLayoutSpecListEntry {
    var entryDescription: String?
    var entryTitle: String?
    var sizeThatFitsBlock: OverviewDisplayNodeSizeThatFitsBlock?

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        if let block = sizeThatFitsBlock {
            return block(constrainedSize)
        }
        return super.layoutSpecThatFits(constrainedSize)
    }
}
