//
//  LayoutExampleNode.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/25.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import AsyncDisplayKit

class LayoutExampleNode: ASDisplayNode {
    
    class var title: String? {
        return nil
    }

    class var descriptionTitle: String? {
        return nil
    }
    
    required override init() {
        super.init()

        automaticallyManagesSubnodes = true
        backgroundColor = UIColor.white
    }
}

class HeaderWithRightAndLeftItems: LayoutExampleNode {
    var usernameNode: ASTextNode!
    var postLocationNode: ASTextNode!
    var postTimeNode: ASTextNode!
    
    override class var title: String? {
        return "Header with left and right justified text"
    }

    override class var descriptionTitle: String? {
        return "try rotating me!"
    }
    
    required init() {
        super.init()
        usernameNode = ASTextNode()
        
        usernameNode.attributedText = NSAttributedString(string: "hannahmbanana", fontSize: 20, color: UIColor.darkBlue)
        usernameNode.maximumNumberOfLines = 1
        usernameNode.truncationMode = .byTruncatingTail

        postLocationNode = ASTextNode()
        postLocationNode.maximumNumberOfLines = 1
        postLocationNode.attributedText = NSAttributedString(string: "Sunset Beach, San Fransisco, CA", fontSize: 20, color: UIColor.lightBlue)
        postLocationNode.maximumNumberOfLines = 1
        postLocationNode.truncationMode = .byTruncatingTail

        postTimeNode = ASTextNode()
        postTimeNode.attributedText = NSAttributedString(string: "30m", fontSize: 20, color: UIColor.lightGray)
        postLocationNode.maximumNumberOfLines = 1
        postLocationNode.truncationMode = .byTruncatingTail
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let nameLocationStack = ASStackLayoutSpec.vertical()
        nameLocationStack.style.flexShrink = 1.0
        nameLocationStack.style.flexGrow = 1.0
        
        if postLocationNode.attributedText != nil {
            nameLocationStack.children = [usernameNode, postLocationNode]
        } else {
            nameLocationStack.children = [usernameNode]
        }

        let headerStackSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 40, justifyContent: .start, alignItems: .center, children: [nameLocationStack, postTimeNode])
        return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(0, 10, 0, 10), child: headerStackSpec)
    }
}

class PhotoWithInsetTextOverlay: LayoutExampleNode {
    var photoNode: ASNetworkImageNode!
    var titleNode: ASTextNode!
    
    override class var title: String? {
        return "Photo with inset text overlay"
    }

    override class var descriptionTitle: String? {
        return "try rotating me!"
    }
    
    required init() {
        super.init()
        backgroundColor = UIColor.clear
        
        photoNode = ASNetworkImageNode()
        photoNode.url = URL(string: "http://uploadfile.deskcity.org/2015/0902/20150902024359322.jpg")
        photoNode.willDisplayNodeContentWithRenderingContext = { context in
            let bounds = context.0.boundingBoxOfClipPath
            UIBezierPath(roundedRect: bounds, cornerRadius: 10).addClip()
        }

        titleNode = ASTextNode()
        titleNode.maximumNumberOfLines = 2
        titleNode.truncationMode = .byTruncatingTail

        titleNode.truncationAttributedText = NSAttributedString(string: "...", fontSize: 16, color: UIColor.red)
        titleNode.attributedText = NSAttributedString(string: "family fall hikes", fontSize: 16, color: UIColor.red)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let photoDimension = constrainedSize.max.width / 4.0
        photoNode.style.preferredSize = CGSize(width: photoDimension, height: photoDimension)
        
        // INFINITY is used to make the inset unbounded
        let insets = UIEdgeInsetsMake(CGFloat.infinity, 12, 12, 12)
        let textInsetSpec = ASInsetLayoutSpec(insets: insets, child: titleNode)

        return ASOverlayLayoutSpec(child: photoNode, overlay: textInsetSpec)
    }
}

class PhotoWithOutsetIconOverlay: LayoutExampleNode {
    var photoNode: ASNetworkImageNode!
    var iconNode: ASNetworkImageNode!
    
    override class var title: String? {
        return "Photo with outset icon overlay"
    }
    
    required init() {
        super.init()
        photoNode = ASNetworkImageNode()
        photoNode.url = URL(string: "http://uploadfile.deskcity.org/2015/0902/20150902024359322.jpg")
        
        iconNode = ASNetworkImageNode()
        iconNode.url = URL(string: "https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcQ8dklGGjkCYbPsk7osPdmYWtd1N7mpEXgXvfU337cZrBwUSaa6")

        iconNode.imageModificationBlock = { image in  // FIXME: in framework autocomplete for setImageModificationBlock line seems broken
            let profileImageSize = CGSize(width: 60, height: 60)
            return image.makeCircularImage(with: profileImageSize, withBorderWidth: 10)
        }
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        iconNode.style.preferredSize = CGSize(width: 40, height: 40)
        iconNode.style.layoutPosition = CGPoint(x: 150, y: 150)

        photoNode.style.preferredSize = CGSize(width: 150, height: 150)
        photoNode.style.layoutPosition = CGPoint(x: 40 / 2.0, y: 40 / 2.0)

        let absoluteSpec = ASAbsoluteLayoutSpec(children: [photoNode, iconNode])

        // ASAbsoluteLayoutSpec's .sizing property recreates the behavior of ASDK Layout API 1.0's "ASStaticLayoutSpec"
        absoluteSpec.sizing = .sizeToFit

        return absoluteSpec
    }
}

class FlexibleSeparatorSurroundingContent: LayoutExampleNode {

    var topSeparator: ASImageNode!
    var bottomSeparator: ASImageNode!
    var textNode: ASTextNode!

    override class var title: String? {
        return "Top and bottom cell separator lines"
    }
    
    override class var descriptionTitle: String? {
        return "try rotating me!"
    }
    
    required init() {
        super.init()
        backgroundColor = UIColor.white
        
        topSeparator = ASImageNode()
        topSeparator.image = UIImage.as_resizableRoundedImage(withCornerRadius: 1, cornerColor: UIColor.black, fill: UIColor.black)

        textNode = ASTextNode()
        textNode.attributedText = NSAttributedString(string: "this is a long text node", fontSize: 16, color: UIColor.black)
        
        bottomSeparator = ASImageNode()
        bottomSeparator.image = UIImage.as_resizableRoundedImage(withCornerRadius: 1, cornerColor: UIColor.black, fill: UIColor.black)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        topSeparator.style.flexGrow = 1.0 // 定义项目的放大比例
        bottomSeparator.style.flexGrow = 1.0
        textNode.style.alignSelf = .center // 允许单个项目有与其他项目不一样的对齐方式,可覆盖align-items属性。默认值为auto，表示继承父元素的align-items属性，如果没有父元素，则等同于stretch。

        let verticalStackSpec = ASStackLayoutSpec.vertical()
        verticalStackSpec.spacing = 20
        verticalStackSpec.justifyContent = .center
        verticalStackSpec.children = [topSeparator, textNode, bottomSeparator]

        return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(60, 0, 60, 0), child: verticalStackSpec)
    }
}
