//
//  CommentsNode.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/26.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

extension RouterKeys {
    static let retweet = "retweet"
    static let comments = "comments"
    static let likes = "likes"
}

class ToolBarButton: ASButtonNode {
    var key = ""
}

class WBStatusToolbarNode: ASDisplayNode {
    
    private var commentsNode: ToolBarButton!
    private var likesNode: ToolBarButton!
    private var retweetNode: ToolBarButton!
    private var line1: GradientLineNode!
    private var line2: GradientLineNode!
    
    init(item: ToolBarModel) {
        super.init()

        backgroundColor = UIColor.white
        borderWidth = onePix
        borderColor = kWBCellLineColor.cgColor

        retweetNode = createButton(with: item.retweet)
        retweetNode.key = RouterKeys.retweet
        addSubnode(retweetNode)

        commentsNode = createButton(with: item.commtens)
        commentsNode.key = RouterKeys.comments
        addSubnode(commentsNode)


        likesNode = createButton(with: item.likes)
        likesNode.key = RouterKeys.likes
        addSubnode(likesNode)

        // TODO: 线
        line1 = gradientLine
        addSubnode(line1)

        line2 = gradientLine
        addSubnode(line2)
    }

    func createButton(with item: (UIImage?, NSAttributedString)) -> ToolBarButton {
        let button = ToolBarButton()
        button.addTarget(self, action: #selector(commentsAction), forControlEvents: .touchUpInside)
        button.contentSpacing = 3
        button.hitTestSlop = UIEdgeInsetsMake(-10, -20, -10, -20)
        button.setImage(item.0, for: .normal)
        button.setAttributedTitle(item.1, for: .normal)
        return button
    }

    var gradientLine: GradientLineNode {
        let gradientLine = GradientLineNode()
        gradientLine.isLayerBacked = true
        gradientLine.isOpaque = false
        gradientLine.style.alignSelf = .start
        gradientLine.style.height = ASDimensionMake(35)
        gradientLine.style.width = ASDimensionMake(onePix)
        return gradientLine
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        let stackNode = ASStackLayoutSpec(direction: .horizontal, spacing: 0, justifyContent: .spaceAround, alignItems: .center, children: [retweetNode, line1, commentsNode, line2, likesNode])

        stackNode.style.height = ASDimensionMake(35)
        stackNode.style.width = ASDimensionMake(screenW)
        return stackNode
    }

    func commentsAction(sender: ToolBarButton) {
        sender.view.router(with: sender.key, userInfo: [sender.key: ""])
    }
}
