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
        
        var nodes: [ASLayoutElement] = []
        
        for result in [[1], [1, 2, 3]] {
            let stack = ASStackLayoutSpec.horizontal()
            stack.spacing = 4
            nodes.append(stack)
            var imageNodes: [ASNetworkImageNode] = []
            for _ in result {
                let imageNode = ASNetworkImageNode()
                imageNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor()
                let preferredSize: CGSize
                if result.count == 1 {
                    preferredSize = CGSize(width: 248, height: 160)
                } else if result.count == 2 {
                    preferredSize = CGSize(width: 122, height: 122)
                } else {
                    preferredSize = CGSize(width: 80, height: 80)
                }
                imageNode.style.preferredSize = preferredSize
                node.addSubnode(imageNode)
                imageNodes.append(imageNode)
            }
            stack.children = imageNodes
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
