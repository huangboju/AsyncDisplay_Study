//
//  WBStatusProfileNode.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/5/11.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class WBStatusProfileNode: ASDisplayNode {
    private var avatarNode: WBStatusPicNode!

    private var nameNode: ASTextNode!
    private var sourceNode: ASTextNode!

    init(item: ProfileModel) {
        super.init()

        backgroundColor = UIColor.white

        // avatarNode
        avatarNode = WBStatusPicNode(badgeName: item.badgeName)
        avatarNode.isLayerBacked = true
        avatarNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor()
        let side: CGFloat = 40
        avatarNode.style.width = ASDimensionMake(side)
        avatarNode.style.height = ASDimensionMake(side)
        avatarNode.cornerRadius = side / 2
        avatarNode.url = item.avatarUrl
        avatarNode.imageModificationBlock = { image in
            return image.corner(with: side)
        }
        addSubnode(avatarNode)

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

        let vstack = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .start, children: [nameNode, sourceNode])
        let mainStack = ASStackLayoutSpec(direction: .horizontal, spacing: 14, justifyContent: .start, alignItems: .start, children: [avatarNode, vstack])

        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), child: mainStack)
    }
}
