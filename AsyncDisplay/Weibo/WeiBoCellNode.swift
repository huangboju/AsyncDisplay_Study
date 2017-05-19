//
//  WeiBoCellNode.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/5/11.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

extension Array {
    func split(by count: Int) -> [[Element]] {
        var result: [[Element]] = []
        for (i, item) in self.enumerated() {
            if result.isEmpty || i % count == 0 {
                result.append([item])
            } else {
                result[i / count].append(item)
            }
        }
        return result
    }
}


class WeiBoCellNode: ASCellNode {
    var weiBoMainNode: WeiBoMainNode!
    
    init(item: MainModel) {
        super.init()

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

    lazy var picNodes: [[ASNetworkImageNode]] = []

    init(item: MainModel) {
        super.init()

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
        textNode.attributedText = item.text
        addSubnode(textNode)


        if let retweetText = item.retweetText {
            retweetBgNode = ASDisplayNode()
            retweetBgNode?.isLayerBacked = true
            retweetBgNode?.backgroundColor = kWBCellBackgroundColor
            addSubnode(retweetBgNode!)

            retweetTextNode = ASTextNode()
            retweetTextNode?.attributedText = retweetText
            addSubnode(retweetTextNode!)
        }

        if let picsMode = item.pics {
            let side = ASDimensionMake(picsMode.count > 1 ? 96 : 148)
            let count = 3
            for (i, item) in picsMode.enumerated() {
                let imageNode = WBStatusPicNode(badgeName: item.badgeName)
                imageNode.backgroundColor = UIColor(white: 0.8, alpha: 1)
                imageNode.style.width = side
                imageNode.style.height = side
                // TODO: 微博的图片是WebP Image
                imageNode.url = item.url
                addSubnode(imageNode)

                if picNodes.isEmpty || i % count == 0 {
                    picNodes.append([imageNode])
                } else {
                    picNodes[i / count].append(imageNode)
                }
            }
        }

        if let card = item.cardModel, item.pics == nil {
            cardNode = WBStatusCardNode(item: card)
            addSubnode(cardNode!)
        }

        toolBarNode = WBStatusToolbarNode(item: item.toolBarModel)
        addSubnode(toolBarNode)
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
            // TODO: Texture 2.2中没有flexWrap，升至Texture 2.3后优化
            let vPicNodes = picNodes.map {
                ASStackLayoutSpec(direction: .horizontal, spacing: 4, justifyContent: .start, alignItems: .start, children: $0)
            }
            // !!!: 当设置为竖直方向时，主轴和交叉轴也会变
            let picsStack = ASStackLayoutSpec(direction: .vertical, spacing: 4, justifyContent: .start, alignItems: .start, children: vPicNodes)

            children.append(picsStack)
            picsStack.style.spacingBefore = 8
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
