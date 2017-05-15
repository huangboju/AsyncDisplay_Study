//
//  WBStatusProfileNode.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/5/11.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class WBStatusProfileNode: ASDisplayNode {
    private var avatarNode: ASNetworkImageNode!
    private var badgeNode: ASImageNode?

    private var nameNode: ASTextNode!
    private var sourceNode: ASTextNode!

    init(item: ProfileModel) {
        super.init()

        // avatarNode
        avatarNode = ASNetworkImageNode()
        avatarNode.isLayerBacked = true
        avatarNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor()
        avatarNode.style.width = ASDimensionMakeWithPoints(40)
        avatarNode.style.height = ASDimensionMakeWithPoints(40)
        avatarNode.cornerRadius = 20
        avatarNode.url = item.avatarUrl
        avatarNode.imageModificationBlock = { image in
            return image.corner(with: 40)
        }
        addSubnode(avatarNode)

        // badge
        if let badge = item.badge {
            badgeNode = ASImageNode()
            badgeNode?.isLayerBacked = true
            badgeNode?.image = badge
            badgeNode?.contentMode = .scaleAspectFit
            addSubnode(badgeNode!)
        }

        // nameNode
        nameNode = ASTextNode()
        nameNode.isLayerBacked = true
        nameNode.attributedText = item.name
        addSubnode(nameNode)

        // sourceNode
        sourceNode = ASTextNode()
        sourceNode.attributedText = item.source
        addSubnode(sourceNode)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        var _avatarNode: ASLayoutElement = avatarNode

        if let badgeNode = badgeNode {
            badgeNode.style.preferredSize = CGSize(width: 14, height: 14)
            badgeNode.style.layoutPosition = CGPoint(x: 28, y: 28)
            _avatarNode = ASAbsoluteLayoutSpec(children: [avatarNode, badgeNode])
        }

        let vstack = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .start, children: [nameNode, sourceNode])

        return ASStackLayoutSpec(direction: .horizontal, spacing: 14, justifyContent: .start, alignItems: .start, children: [_avatarNode, vstack])
    }
}
