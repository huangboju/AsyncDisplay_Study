//
//  WeiBoCellNode.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/5/11.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class WeiBoCellNode: ASCellNode {
    var vipBackgroundNode: ASNetworkImageNode!
    var titleNode: WBStatusTitleNode?
    var profileNode: WBStatusProfileNode!
    var textNode: ASTextNode!
    var retweetTextNode: ASTextNode?
    var toolBarNode: WBStatusToolbarNode!

    init(item: WBModel) {
        super.init()

        backgroundColor = kWBCellInnerViewColor

        vipBackgroundNode = ASNetworkImageNode()
        vipBackgroundNode.url = item.vipUrl
        vipBackgroundNode.imageModificationBlock = { image in
            return UIImage(cgImage: image.cgImage!, scale: 2, orientation: image.imageOrientation)
        }
        vipBackgroundNode.isLayerBacked = true
        vipBackgroundNode.contentMode = .topRight
        vipBackgroundNode.style.height = ASDimensionMake(14)
        vipBackgroundNode.style.width = ASDimensionMake(screenW)
        addSubnode(vipBackgroundNode)

        if let titleModel = item.titleModel {
            titleNode = WBStatusTitleNode(item: titleModel)
            addSubnode(titleNode!)
        }

        profileNode = WBStatusProfileNode(item: item.profileModel)
        addSubnode(profileNode)

        textNode = ASTextNode()
        textNode.attributedText = item.text
        addSubnode(textNode)


        if let retweetText = item.retweetText {
            retweetTextNode = ASTextNode()
            retweetTextNode?.attributedText = retweetText
            addSubnode(retweetTextNode!)
        }

        toolBarNode = WBStatusToolbarNode(item: item.toolBarModel)
        addSubnode(toolBarNode)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        var children: [ASLayoutElement] = []

        let mainInsets = UIEdgeInsets(top: 8, left: 12, bottom: 0, right: 12)

        // titleView
        if let titleView = titleNode {
            children.append(titleView)
        }

        // profileNode
        children.append(profileNode)

        // textNode
        textNode.style.spacingBefore = 10
        children.append(textNode)
        
        // retweetTextNode
        if let retweetTextNode = retweetTextNode {
            retweetTextNode.style.spacingBefore = 15
            children.append(retweetTextNode)
        }

        let headerStack = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .start, children: children)

        // profileStack
        let profileInset = ASInsetLayoutSpec(insets: mainInsets, child: headerStack)
        children = [vipBackgroundNode, profileInset]

        // toolBar
        children.append(toolBarNode)

        let mainStack = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .start, children: children)

        return mainStack
    }
}
