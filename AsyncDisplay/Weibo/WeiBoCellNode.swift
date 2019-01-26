//
//  WeiBoCellNode.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/5/11.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import AsyncDisplayKit

class WeiBoCellNode: ASCellNode {
    var weiBoMainNode: WeiBoMainNode!

    convenience init(item: MainModel) {
        self.init()

        selectionStyle = .none
        backgroundColor = kWBCellBackgroundColor

        weiBoMainNode = WeiBoMainNode(item: item)
        addSubnode(weiBoMainNode)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: kWBCellTopMargin, left: 0, bottom: 0, right: 0), child: weiBoMainNode)
    }
}


class WeiBoMainNode: ASDisplayNode {

    var vipBackgroundNode: ASNetworkImageNode!
    var titleNode: WBStatusTitleNode?
    var profileNode: WBStatusProfileNode!
    var textNode: ASTextNode!
    var retweetTextNode: ASTextNode?
    var toolBarNode: WBStatusToolbarNode!
    var cardNode: WBStatusCardNode?

    var retweetBgNode: ASDisplayNode?

    lazy var picNodes: [ASInsetLayoutSpec] = []
    
    var linkManager: LinkManager?

    convenience init(item: MainModel) {
        self.init()

        backgroundColor = UIColor.white
        borderWidth = onePix
        borderColor = kWBCellLineColor.cgColor

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
        textNode.isUserInteractionEnabled = true
        textNode.attributedText = item.text
        linkManager = LinkManager()
        textNode.delegate = linkManager
        textNode.linkAttributeNames = [kLinkAttributeName.rawValue]
        addSubnode(textNode)

        if let retweetText = item.retweetText {
            retweetBgNode = ASDisplayNode()
            retweetBgNode?.isLayerBacked = true
            retweetBgNode?.backgroundColor = kWBCellBackgroundColor
            addSubnode(retweetBgNode!)

            retweetTextNode = ASTextNode()
            retweetTextNode?.isUserInteractionEnabled = true
            retweetTextNode?.delegate = linkManager
            retweetTextNode?.linkAttributeNames = [kLinkAttributeName.rawValue]
            retweetTextNode?.attributedText = retweetText
            addSubnode(retweetTextNode!)
        }

        if let picsMode = item.pics {
            let side = ASDimensionMake(picsMode.count > 1 ? 96 : 148)
            for item in picsMode {
                let imageNode = WBStatusPicNode(badgeName: item.badgeName)
                imageNode.backgroundColor = UIColor(white: 0.8, alpha: 1)
                imageNode.style.width = side
                imageNode.style.height = side
                // TODO: 微博的图片是WebP Image
                imageNode.url = item.url
                addSubnode(imageNode)
                picNodes.append(ASInsetLayoutSpec(insets: UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 4), child: imageNode))
            }
        }

        if let card = item.cardModel, item.pics == nil {
            cardNode = WBStatusCardNode(item: card)
            addSubnode(cardNode!)
        }

        toolBarNode = WBStatusToolbarNode(item: item.toolBarModel)
        addSubnode(toolBarNode)
    }

    // 这个是控制可点击字符串的高亮
    override func didLoad() {
        // enable highlighting now that self.layer has loaded -- see ASHighlightOverlayLayer.h
        layer.as_allowsHighlightDrawing = true
        super.didLoad()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        var children: [ASLayoutElement] = [vipBackgroundNode]

        // titleView
        if let titleView = titleNode {
            children.append(titleView)
        }

        let headerStack = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .start, children: children)

        // profileNode textNode
        textNode.style.spacingBefore = kWBCellPaddingText
        children = [profileNode, textNode]

        let profileAndTextStack = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .start, children: children)
        let top: CGFloat = titleNode != nil ? 12 : 0
        let profileAndTextInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: top, left: kWBCellPadding, bottom: 0, right: kWBCellPadding), child: profileAndTextStack)

        children = []

        // retweetTextNode
        if let retweetTextNode = retweetTextNode {
            children.append(retweetTextNode)
        }

        // picNodesStack
        if !picNodes.isEmpty {
            // !!!: 当设置为竖直方向时，主轴和交叉轴也会变
            let picsStack = ASStackLayoutSpec(direction: .horizontal, spacing: 0, justifyContent: .start, alignItems: .start, children: picNodes)

            children.append(picsStack)
            picsStack.style.spacingBefore = 8
            picsStack.flexWrap = .wrap
        }

        if let cardNode = cardNode {
            cardNode.style.spacingBefore = 8
            children.append(cardNode)
        }

        let retweetStack = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .start, children: children)
        let retweetInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12), child: retweetStack)

        let footerStack = ASStackLayoutSpec(direction: .vertical, spacing: kWBCellPaddingText, justifyContent: .start, alignItems: .start, children: [retweetInset, toolBarNode])

        let retweetBgLayout = ASBackgroundLayoutSpec(child: footerStack, background: retweetBgNode ?? ASLayoutSpec())
        retweetBgLayout.style.spacingBefore = kWBCellPaddingText

        children = [headerStack, profileAndTextInset, retweetBgLayout]

        let mainStack = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .start, children: children)

        return mainStack
    }
}
