//
//  WBStatusPicNode.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/5/16.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class WBStatusPicNode: ASNetworkImageNode {
    var badgeNode: ASImageNode?

    convenience init(badgeName: String?) {
        self.init()
        if let badgeName = badgeName {
            badgeNode = ASImageNode()
            let badge = WBStatusHelper.image(with: badgeName)
            badgeNode?.image = badge
            badgeNode?.isLayerBacked = true
            badgeNode?.style.width = ASDimensionMake(badge?.size.width ?? 0)
            badgeNode?.style.height = ASDimensionMake(badge?.size.height ?? 0)
            addSubnode(badgeNode!)
        }
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASRelativeLayoutSpec(horizontalPosition: .end, verticalPosition: .end, sizingOption: [], child: badgeNode ?? ASLayoutSpec())
    }
}
