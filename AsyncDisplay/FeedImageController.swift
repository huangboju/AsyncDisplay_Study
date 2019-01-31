//
//  FeedImageController.swift
//  AsyncDisplay
//
//  Created by xiAo_Ju on 2019/1/30.
//  Copyright © 2019 伯驹 黄. All rights reserved.
//

import UIKit

class FeedImageController: ASViewController<ASDisplayNode> {

    init() {
        super.init(node: ASDisplayNode())
        
        var nodes: [ASStackLayoutSpec] = []
        
        let count = 7
        let v = count % 3
        for i in 0 ..< count {
            let imageNode = ASNetworkImageNode()
            imageNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor()
            let preferredSize: CGSize
            if v == 1 && v > i {
                preferredSize = CGSize(width: 248, height: 160)
            } else if v == 2 && v > i {
                preferredSize = CGSize(width: 122, height: 122)
            } else {
                preferredSize = CGSize(width: 80, height: 80)
            }
            imageNode.style.preferredSize = preferredSize
            node.addSubnode(imageNode)
            if nodes.isEmpty || i % 3 == 0 {
                let stack = ASStackLayoutSpec.horizontal()
                stack.spacing = 4
                stack.children = [imageNode]
                nodes.insert(stack, at: 0)
            } else {
                nodes[i/3].children?.append(imageNode)
            }
        }
        
        node.layoutSpecBlock = { _, _ in
            let stack = ASStackLayoutSpec.vertical()
            stack.children = nodes
            stack.spacing = 4
            
            return ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: stack)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
