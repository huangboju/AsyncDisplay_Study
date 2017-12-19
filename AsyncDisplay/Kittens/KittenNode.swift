//
//  KittenNode.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/25.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

private let kImageSize: CGFloat = 80.0
private let kOuterPadding: CGFloat = 16.0
private let kInnerPadding: CGFloat = 10.0

var _placeholders: [String]!

import AsyncDisplayKit

class KittenNode: ASCellNode {
    private var kittenSize: CGSize
    
    private var imageNode: ASNetworkImageNode!
    private var textNode: ASTextNode!
    private var divider: ASDisplayNode!
    private var isImageEnlarged = false
    private var swappedTextAndImage = false
    

    // lorem ipsum text courtesy https://kittyipsum.com/ <3
    static var placeholders: [String] {
        
        if _placeholders == nil {
            _placeholders = [
                "Kitty ipsum dolor sit amet, purr sleep on your face lay down in your way biting, sniff tincidunt a etiam fluffy fur judging you stuck in a tree kittens.",
                "Lick tincidunt a biting eat the grass, egestas enim ut lick leap puking climb the curtains lick.",
                "Lick quis nunc toss the mousie vel, tortor pellentesque sunbathe orci turpis non tail flick suscipit sleep in the sink.",
                "Orci turpis litter box et stuck in a tree, egestas ac tempus et aliquam elit.",
                "Hairball iaculis dolor dolor neque, nibh adipiscing vehicula egestas dolor aliquam.",
                "Sunbathe fluffy fur tortor faucibus pharetra jump, enim jump on the table I don't like that food catnip toss the mousie scratched.",
                "Quis nunc nam sleep in the sink quis nunc purr faucibus, chase the red dot consectetur bat sagittis.",
                "Lick tail flick jump on the table stretching purr amet, rhoncus scratched jump on the table run.",
                "Suspendisse aliquam vulputate feed me sleep on your keyboard, rip the couch faucibus sleep on your keyboard tristique give me fish dolor.",
                "Rip the couch hiss attack your ankles biting pellentesque puking, enim suspendisse enim mauris a.",
                "Sollicitudin iaculis vestibulum toss the mousie biting attack your ankles, puking nunc jump adipiscing in viverra.",
                "Nam zzz amet neque, bat tincidunt a iaculis sniff hiss bibendum leap nibh.",
                "Chase the red dot enim puking chuf, tristique et egestas sniff sollicitudin pharetra enim ut mauris a.",
                "Sagittis scratched et lick, hairball leap attack adipiscing catnip tail flick iaculis lick.",
                "Neque neque sleep in the sink neque sleep on your face, climb the curtains chuf tail flick sniff tortor non.",
                "Ac etiam kittens claw toss the mousie jump, pellentesque rhoncus litter box give me fish adipiscing mauris a.",
                "Pharetra egestas sunbathe faucibus ac fluffy fur, hiss feed me give me fish accumsan.",
                "Tortor leap tristique accumsan rutrum sleep in the sink, amet sollicitudin adipiscing dolor chase the red dot.",
                "Knock over the lamp pharetra vehicula sleep on your face rhoncus, jump elit cras nec quis quis nunc nam.",
                "Sollicitudin feed me et ac in viverra catnip, nunc eat I don't like that food iaculis give me fish.",
            ]
        }
        
        return _placeholders
    }

    init(size: CGSize) {
        self.kittenSize = size
        super.init()

        // kitten image, with a solid background colour serving as placeholder
        imageNode = ASNetworkImageNode()
        imageNode.url = URL(string: "https://placekitten.com/\(Int(round(kittenSize.width)))/\(Int(round(kittenSize.height)))")
        imageNode.placeholderFadeDuration = 0.5
    
        imageNode.placeholderColor = ASDisplayNodeDefaultPlaceholderColor()
        //  _imageNode.contentMode = UIViewContentModeCenter
        imageNode.addTarget(self, action: #selector(toggleNodesSwap), forControlEvents: .touchUpInside)
        addSubnode(imageNode)

        // lorem ipsum text, plus some nice styling
        textNode = ASTextNode()
        textNode.attributedText = NSAttributedString(string: kittyIpsum, attributes: textStyle)
        addSubnode(textNode)

        // hairline cell separator
        divider = ASDisplayNode()
        divider.backgroundColor = UIColor.lightGray
        addSubnode(divider)
    }

    var kittyIpsum: String {
        let placeholders = KittenNode.placeholders
        let ipsumCount = UInt32(placeholders.count)
        let location = arc4random_uniform(ipsumCount)
        let length = max(1, arc4random_uniform(ipsumCount - location))

        var string = placeholders[Int(location)]
        for i in Int(location) + 1 ..< Int(location + length) {
            string.append((i % 2 == 0) ? "\n" : "  ")
            string.append(placeholders[i])
        }

        return string
    }
    
    var textStyle: [NSAttributedStringKey: Any] {
        
        let font = UIFont(name: "HelveticaNeue", size: 12)!
        
        let style = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        style.paragraphSpacing = 0.5 * font.lineHeight
        style.hyphenationFactor = 1.0

        return [
            .font: font,
            .paragraphStyle: style,
             NSAttributedStringKey(ASTextNodeWordKerningAttributeName): 0.5
        ]
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        // Set an intrinsic size for the image node
        let imageSize = isImageEnlarged ? CGSize(width: 2.0 * kImageSize, height: 2.0 * kImageSize) : CGSize(width: kImageSize, height: kImageSize)
        imageNode.style.preferredSize = imageSize

        // Shrink the text node in case the image + text gonna be too wide
        textNode.style.flexShrink = 1.0

        // Configure stack

        let stackLayoutSpec =
            ASStackLayoutSpec(direction: .horizontal, spacing: kInnerPadding, justifyContent: .start, alignItems: .start, children: swappedTextAndImage ? [textNode, imageNode] : [imageNode, textNode])

        // Add inset
        return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(kOuterPadding, kOuterPadding, kOuterPadding, kOuterPadding), child: stackLayoutSpec)
    }

    // With box model, you don't need to override this method, unless you want to add custom logic.
    override func layout() {
        super.layout()
        // Manually layout the divider.
        let pixelHeight = 1.0 / UIScreen.main.scale
        divider.frame = CGRect(x: 0.0, y: 0.0, width: calculatedSize.width, height: pixelHeight)
    }

    func toggleImageEnlargement() {
        isImageEnlarged = !isImageEnlarged
        setNeedsLayout()
    }

    @objc func toggleNodesSwap() {
        swappedTextAndImage = !swappedTextAndImage

        UIView.animate(withDuration: 0.15, animations: { 
            self.alpha = 0
        }, completion: { _ in
            self.setNeedsLayout()
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.15) {
                self.alpha = 1
            }
        })
    }

    func updateBackgroundColor() {
        if isHighlighted {
            backgroundColor = UIColor.lightGray
        } else if isSelected {
            backgroundColor = UIColor.blue
        } else {
            backgroundColor = UIColor.white
        }
    }

    override var isSelected: Bool {
        didSet {
            updateBackgroundColor()
        }
    }

    override var isHighlighted: Bool {
        didSet {
            updateBackgroundColor()
        }
    }
}
