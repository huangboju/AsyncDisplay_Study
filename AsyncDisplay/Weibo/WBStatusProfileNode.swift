//
//  WBStatusProfileNode.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/5/11.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import AsyncDisplayKit

class WBStatusProfileNode: ASDisplayNode {
    private var avatarNode: WBStatusPicNode!

    private var nameNode: ASTextNode!
    private var sourceNode: ASTextNode!
    
    var linkManager: LinkManager?

    init(item: ProfileModel) {
        super.init()

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
        sourceNode.linkAttributeNames = [kLinkAttributeName.rawValue]
        linkManager = LinkManager()
        sourceNode.delegate = linkManager
        sourceNode.isUserInteractionEnabled = true
        addSubnode(sourceNode)
    }

    // 这个是控制可点击字符串的高亮
    override func didLoad() {
        // enable highlighting now that self.layer has loaded -- see ASHighlightOverlayLayer.h
        layer.as_allowsHighlightDrawing = true
        super.didLoad()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        let vstack = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .start, children: [nameNode, sourceNode])
        let mainStack = ASStackLayoutSpec(direction: .horizontal, spacing: 14, justifyContent: .start, alignItems: .start, children: [avatarNode, vstack])

        return mainStack
    }
}
