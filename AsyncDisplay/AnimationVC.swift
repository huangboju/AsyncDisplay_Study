//
//  AnimationVC.swift
//  AsyncDisplay
//
//  Created by xiAo_Ju on 2019/2/20.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import UIKit

class AnimationNode: ASDisplayNode {
    let node = ASDisplayNode()
    var isShowing = false
    
    override init() {
        super.init()
        node.backgroundColor = .red
        automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        node.style.preferredSize = CGSize(width: 100, height: 34)
        
        return ASCenterLayoutSpec(horizontalPosition: .end, verticalPosition: .center, sizingOption: [], child: ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15), child: node))
    }
    
    func show() {
        isShowing = !isShowing
        transitionLayout(withAnimation: true, shouldMeasureAsync: false, measurementCompletion: nil)
    }
    
    override func animateLayoutTransition(_ context: ASContextTransitioning) {
        let toNodeFrame = context.finalFrame(for: node)
        node.frame.origin.x = isShowing ? toNodeFrame.maxX : toNodeFrame.minX
//        node.frame.size.width = isShowing ? 0 : 100
        
        UIView.animate(withDuration: defaultLayoutTransitionDuration, delay: 0, usingSpringWithDamping: isShowing ? 0.8 : 1, initialSpringVelocity: 0.8, options: isShowing ? .curveEaseOut : .curveLinear, animations: {
            self.node.frame.origin.x = self.isShowing ? toNodeFrame.minX : toNodeFrame.maxX
//            self.node.frame.size.width = self.isShowing ? 100 : 0
        }, completion: {
            context.completeTransition($0)
        })
    }

}

class AnimationVC: UIViewController {
    
    let node = AnimationNode()

    override func viewDidLoad() {
        super.viewDidLoad()
        node.backgroundColor = UIColor(white: 0.9, alpha: 1)
        view.addSubnode(node)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        node.show()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        node.frame = view.bounds
    }

}
