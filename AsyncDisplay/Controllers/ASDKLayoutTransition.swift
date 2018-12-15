//
//  ASDKLayoutTransition.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/20.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import AsyncDisplayKit

class TransitionNode: ASDisplayNode {
    var isEnabled  = false
    
    var buttonNode: ASButtonNode!
    var textNodeOne: ASTextNode!
    var textNodeTwo: ASTextNode!
    
    override init() {
        super.init()

        defaultLayoutTransitionDuration = 1

        textNodeOne = ASTextNode()
        textNodeOne.attributedText = NSAttributedString(string: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled")

        textNodeTwo = ASTextNode()
        textNodeTwo.attributedText = NSAttributedString(string: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English.")

        // Setup button
        let buttonTitle = "Start Layout Transition"
        let buttonFont = UIFont.systemFont(ofSize:16.0)
        let buttonColor = UIColor.blue

        buttonNode = ASButtonNode()
        buttonNode.setTitle(buttonTitle, with: buttonFont, with: buttonColor, for: .normal)
        buttonNode.setTitle(buttonTitle, with: buttonFont, with: buttonColor.withAlphaComponent(0.5), for: .highlighted)
        addSubnode(buttonNode)

        // Some debug colors
        textNodeOne.backgroundColor = UIColor.orange
        textNodeTwo.backgroundColor = UIColor.green
    
        // 自动管理node
        automaticallyManagesSubnodes = true
    }

    override func didLoad() {
        super.didLoad()
        buttonNode.addTarget(self, action: #selector(buttonPressed), forControlEvents: .touchUpInside)
    }

    // MARK: - Actions

    @objc func buttonPressed() {
        isEnabled = !isEnabled
        transitionLayout(withAnimation: true, shouldMeasureAsync: false, measurementCompletion: nil)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let nextTextNode = isEnabled ? textNodeTwo : textNodeOne
        nextTextNode!.style.flexGrow = 1.0
        nextTextNode!.style.flexShrink = 1.0

        // 搞不懂为什么要包一层
        let horizontalStackLayout = ASStackLayoutSpec.horizontal()
        horizontalStackLayout.children = [nextTextNode!]

        
        buttonNode.style.alignSelf = .center
        let verticalStackLayout = ASStackLayoutSpec.vertical()
        verticalStackLayout.spacing = 10.0
        verticalStackLayout.children = [horizontalStackLayout, buttonNode]

        return ASInsetLayoutSpec(insets: UIEdgeInsets.init(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0), child: verticalStackLayout)
    }
    
    override func animateLayoutTransition(_ context: ASContextTransitioning) {
        
        let fromNode = context.removedSubnodes()[0]
        let toNode = context.insertedSubnodes()[0]
        
        var tempbuttonNode: ASButtonNode?
        
        for node in context.subnodes(forKey: ASTransitionContextToLayoutKey) {
            if let node = node as? ASButtonNode {
                tempbuttonNode = node
                break
            }
        }
        

        var toNodeFrame = context.finalFrame(for: toNode)
        let width = isEnabled ? toNodeFrame.width : -toNodeFrame.width
        toNodeFrame.origin.x += width
        toNode.frame = toNodeFrame
        toNode.alpha = 0.0

        var fromNodeFrame = fromNode.frame
        let width1 = isEnabled ? -fromNodeFrame.width : fromNodeFrame.width
        fromNodeFrame.origin.x += width1

        // We will use the same transition duration as the default transition
        UIView.animate(withDuration: defaultLayoutTransitionDuration, animations: {
            toNode.alpha = 1.0

            fromNode.alpha = 0.0

            // Update frame of self

            let fromSize = context.layout(forKey: ASTransitionContextFromLayoutKey)!.size
            let toSize = context.layout(forKey: ASTransitionContextToLayoutKey)!.size
            let isResized = fromSize != toSize
            if isResized {
                self.frame.size = toSize
            }

            tempbuttonNode?.frame = context.finalFrame(for: tempbuttonNode!)
        }, completion: {
            context.completeTransition($0)
        })
    }
}

class ASDKLayoutTransition: UIViewController {
    
    var transitionNode = TransitionNode()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubnode(transitionNode)

        transitionNode.backgroundColor = UIColor.gray
    
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let size = transitionNode.layoutThatFits(ASSizeRange(min: .zero, max: view.frame.size)).size
        transitionNode.frame = CGRect(x: 0, y: 100, width: size.width, height: size.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
