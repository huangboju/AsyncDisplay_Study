//
//  CommentsNode.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/26.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class WBCommentsNode: ASControlNode {
    let iconNode = ASImageNode()
    let countNode = ASTextNode()

    init(commentsCount: Int) {
        super.init()
        
        iconNode.image = WBStatusHelper.image(with: "timeline_icon_comment")
        addSubnode(iconNode)

        countNode.attributedText = NSAttributedString(string: commentsCount > 0 ? "\(commentsCount)" : "评论", attributes: TextStyles.cellControlStyle)
        addSubnode(countNode)

        // make it tappable easily
        hitTestSlop = UIEdgeInsetsMake(-10, -10, -10, -10)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let mainStack = ASStackLayoutSpec(direction: .horizontal, spacing: 3, justifyContent: .center, alignItems: .center, children: [iconNode, countNode])
        return mainStack
    }
}


class WBLikesNode: ASControlNode {
    let iconNode = ASImageNode()
    let countNode = ASTextNode()
    
    init(likes: Int) {
        super.init()
        
        iconNode.image = WBStatusHelper.image(with: "timeline_icon_unlike")
        addSubnode(iconNode)

        countNode.attributedText = NSAttributedString(string: likes > 0 ? "\(likes)" : "赞", attributes: TextStyles.cellControlStyle)
        addSubnode(countNode)
        
        // make it tappable easily
        hitTestSlop = UIEdgeInsetsMake(-10, -10, -10, -10)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let mainStack = ASStackLayoutSpec(direction: .horizontal, spacing: 3, justifyContent: .center, alignItems: .center, children: [iconNode, countNode])
        
        return mainStack
    }
}

class WBRetweetNode: ASControlNode {
    let iconNode = ASImageNode()
    let countNode = ASTextNode()
    
    init(retweets: Int) {
        super.init()

        iconNode.image = WBStatusHelper.image(with: "timeline_icon_retweet")
        addSubnode(iconNode)

        countNode.attributedText = NSAttributedString(string: retweets > 0 ? "\(retweets)" : "转发", attributes: TextStyles.cellControlStyle)
        addSubnode(countNode)

        // make it tappable easily
        hitTestSlop = UIEdgeInsetsMake(-10, -10, -10, -10)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let mainStack = ASStackLayoutSpec(direction: .horizontal, spacing: 3, justifyContent: .center, alignItems: .center, children: [iconNode, countNode])

        return mainStack
    }
}

class WBStatusToolbarNode: ASDisplayNode {
    
    private var commentsNode: WBCommentsNode!
    private var likesNode: WBLikesNode!
    private var retweetNode: WBRetweetNode!
    private var line1: GradientLineNode!
    private var line2: GradientLineNode!
    
    init(item: ToolBarModel) {
        super.init()

        backgroundColor = UIColor.white
        borderWidth = onePix
        borderColor = kWBCellLineColor.cgColor

        retweetNode = WBRetweetNode(retweets: item.retweetNode)
        addSubnode(retweetNode)

        commentsNode = WBCommentsNode(commentsCount: item.commtens)
        addSubnode(commentsNode)

        likesNode = WBLikesNode(likes: item.likes)
        addSubnode(likesNode)

        // TODO: 线
        line1 = gradientLine
        addSubnode(line1)

        line2 = gradientLine
        addSubnode(line2)
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
}
