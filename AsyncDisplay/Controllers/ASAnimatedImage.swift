//
//  ASAnimatedImage.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/19.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import AsyncDisplayKit

class ASAnimatedImage: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let imageNode = ASNetworkImageNode()

        imageNode.url = URL(string: "http://ww2.sinaimg.cn/or360/6fc6f04egw1evuciu6zqlj20hs0vkab3.jpg")
        imageNode.delegate = self
        imageNode.frame = view.bounds
        imageNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageNode.contentMode = .scaleAspectFit
//        view.addSubnode(imageNode)

        navigationItem.showTitleView(text: "Loading")
        
        
        let postNode = ASTextNode()
        postNode.frame = CGRect(x: 0, y: 64, width: screenW, height: 100)
        let kLinkAttributeName = NSAttributedStringKey("TextLinkAttributeName")
        let str = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. https://github.com/facebook/AsyncDisplayKit Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."

        let attrString = NSMutableAttributedString(string: str, attributes: TextStyles.postStyle)

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
        postNode.linkAttributeNames = [kLinkAttributeName.rawValue]
        postNode.attributedText = attrString
        postNode.passthroughNonlinkTouches = true

        view.addSubnode(postNode)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ASAnimatedImage: ASTextNodeDelegate {

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

extension ASAnimatedImage: ASNetworkImageNodeDelegate {
    func imageNode(_ imageNode: ASNetworkImageNode, didLoad image: UIImage) {
        navigationItem.hideTitleView()
    }
}
