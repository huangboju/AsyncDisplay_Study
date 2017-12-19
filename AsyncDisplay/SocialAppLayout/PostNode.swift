//
//  PostNode.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/26.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import AsyncDisplayKit

// Processing URLs in post
let kLinkAttributeName = "TextLinkAttributeName"

class SocialSingleton {
    static let shared = SocialSingleton()
    
    private var _urlDetector: NSDataDetector?

    var urlDetector: NSDataDetector? {
        if _urlDetector == nil {
            _urlDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        }
        return _urlDetector
    }
    
    private init() {}
}

class PostNode: ASCellNode {
    let divider = ASDisplayNode()
    let nameNode = ASTextNode()
    let usernameNode = ASTextNode()
    let timeNode = ASTextNode()
    let postNode = ASTextNode()
    var viaNode: ASImageNode?
    let avatarNode = ASNetworkImageNode()
    var mediaNode: ASNetworkImageNode?
    var likesNode: LikesNode!
    var commentsNode: CommentsNode!
    var optionsNode: ASImageNode!

    init(post: Post) {
        super.init()
        
        selectionStyle = .none

        // Name node
        nameNode.attributedText = NSAttributedString(string: post.name, attributes: TextStyles.nameStyle)
        nameNode.maximumNumberOfLines = 1
        addSubnode(nameNode)
        
        
        // Username node
        usernameNode.attributedText = NSAttributedString(string: post.username, attributes: TextStyles.usernameStyle)
        usernameNode.style.flexShrink = 1.0 //if name and username don't fit to cell width, allow username shrink
        usernameNode.truncationMode = .byTruncatingTail
        usernameNode.maximumNumberOfLines = 1
        addSubnode(usernameNode)
        
        
       
        // Time node
        timeNode.attributedText = NSAttributedString(string: post.time, attributes: TextStyles.timeStyle)
        addSubnode(timeNode)
        
        if !post.post.isEmpty {
            
            let attrString = NSMutableAttributedString(string: post.post, attributes: TextStyles.postStyle)

            let urlDetector = SocialSingleton.shared.urlDetector

            urlDetector?.enumerateMatches(in: attrString.string, options: [], range: NSMakeRange(0, attrString.string.length), using: { (result, flags, stop) in
                if result?.resultType == NSTextCheckingResult.CheckingType.link {

                    var linkAttributes = TextStyles.postLinkStyle
                    linkAttributes[kLinkAttributeName] = URL(string: (result?.url?.absoluteString)!)

                    attrString.addAttributes(linkAttributes, range: (result?.range)!)
                }
            })

            // Configure node to support tappable links
            postNode.delegate = self
            postNode.isUserInteractionEnabled = true
            postNode.linkAttributeNames = [kLinkAttributeName]
            postNode.attributedText = attrString
            postNode.passthroughNonlinkTouches = true   // passes touches through when they aren't on a link
        }

        addSubnode(postNode)
        

        // Media
        if !post.media.isEmpty {
            
            mediaNode = ASNetworkImageNode()
            mediaNode?.backgroundColor = ASDisplayNodeDefaultPlaceholderColor()
            mediaNode?.cornerRadius = 4.0
            mediaNode?.url = URL(string: post.media)
            mediaNode?.delegate = self
            mediaNode?.imageModificationBlock = { image in
                return image.corner(with: 8)
            }
            addSubnode(mediaNode!)
        }
        
        
        // User pic
        avatarNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor()
        avatarNode.style.width = ASDimensionMakeWithPoints(44)
        avatarNode.style.height = ASDimensionMakeWithPoints(44)
        avatarNode.cornerRadius = 22.0
        avatarNode.url = URL(string: post.photo)
        avatarNode.imageModificationBlock = { image in
            return image.corner(with: 44)
            
        }
        addSubnode(avatarNode)
        
        // Hairline cell separator
        updateDividerColor()
        addSubnode(divider)
        
        // Via
        if post.via != 0 {
            viaNode = ASImageNode()
            viaNode?.image = UIImage(named: (post.via == 1) ? "icon_ios" : "icon_android")
            addSubnode(viaNode!)
        }

        // Bottom controls
        likesNode = LikesNode(likesCount: post.likes)
        addSubnode(likesNode)

        commentsNode = CommentsNode(comentsCount: post.comments)
        addSubnode(commentsNode)

        optionsNode = ASImageNode()
        optionsNode.image = UIImage(named: "icon_more")
        addSubnode(optionsNode)

        for node in subnodes where node != postNode {
            node.isLayerBacked = true
        }
    }

    func updateDividerColor() {
        /*
         * UITableViewCell traverses through all its descendant views and adjusts their background color accordingly
         * either to [UIColor clearColor], although potentially it could use the same color as the selection highlight itself.
         * After selection, the same trick is performed again in reverse, putting all the backgrounds back as they used to be.
         * But in our case, we don't want to have the background color disappearing so we reset it after highlighting or
         * selection is done.
         */
        divider.backgroundColor = UIColor.lightGray
    }

    override func didLoad() {
        // enable highlighting now that self.layer has loaded -- see ASHighlightOverlayLayer.h
        layer.as_allowsHighlightDrawing = true
        super.didLoad()
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        // Flexible spacer between username and time
        let spacer = ASLayoutSpec() // 占位
        spacer.style.flexGrow = 1.0 // 项目的放大比例，默认为0，即如果存在剩余空间，也不放大
        

        // Horizontal stack for name, username, via icon and time
        var layoutSpecChildren: [ASLayoutElement] = [nameNode, usernameNode, spacer]
        if let viaNode = viaNode {
            layoutSpecChildren.append(viaNode)
        }
        layoutSpecChildren.append(timeNode)

        let nameStack = ASStackLayoutSpec(direction: .horizontal, spacing: 5, justifyContent: .start, alignItems: .center, children: layoutSpecChildren)
        nameStack.style.alignSelf = .stretch // 伸展

        // bottom controls horizontal stack

        let controlsStack = ASStackLayoutSpec(direction: .horizontal, spacing: 10, justifyContent: .start, alignItems: .center, children: [likesNode, commentsNode, optionsNode])

        // Add more gaps for control line
        controlsStack.style.spacingAfter = 3.0
        controlsStack.style.spacingBefore = 3.0

        var mainStackContent: [ASLayoutElement] = [nameStack, postNode]


        // Only add the media node if an image is present
        if let mediaNode = mediaNode {
            let imagePlace = ASRatioLayoutSpec(ratio: 0.5, child: mediaNode)
            imagePlace.style.spacingAfter = 3.0
            imagePlace.style.spacingBefore = 3.0
            mainStackContent.append(imagePlace)
        }
        mainStackContent.append(controlsStack)


        // Vertical spec of cell main content
        let contentSpec = ASStackLayoutSpec(direction: .vertical, spacing: 8, justifyContent: .start, alignItems: .stretch, children: mainStackContent)
        contentSpec.style.flexShrink = 1.0 // 收缩
        

        // Horizontal spec for avatar
        let avatarContentSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 8, justifyContent: .start, alignItems: .start, children: [avatarNode, contentSpec])

        return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(10, 10, 10, 10), child: avatarContentSpec)
    }

    override func layout() {
        super.layout()
    
        // Manually layout the divider.
        let pixelHeight = 1.0 / UIScreen.main.scale
        divider.frame = CGRect(x: 0.0, y: 0.0, width: calculatedSize.width, height: pixelHeight)
    }

    override var isHighlighted: Bool {
        didSet {
            updateDividerColor()
        }
    }

    override var isSelected: Bool {
        didSet {
            updateDividerColor()
        }
    }
}

extension PostNode: ASNetworkImageNodeDelegate {
    func imageNode(_ imageNode: ASNetworkImageNode, didLoad image: UIImage) {
        setNeedsLayout()
    }
}


extension PostNode: ASTextNodeDelegate {

    func textNode(_ textNode: ASTextNode, shouldHighlightLinkAttribute attribute: String, value: Any, at point: CGPoint) -> Bool {
        return true
    }

    func textNode(_ textNode: ASTextNode, tappedLinkAttribute attribute: String, value: Any, at point: CGPoint, textRange: NSRange) {
        guard let url = value as? URL else {
            return
        }
        UIApplication.shared.openURL(url)
    }
}
