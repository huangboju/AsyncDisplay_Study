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
        
        for result in [[1,2], [1,2,3], [1,2,3]] {
            let stack = ASStackLayoutSpec.horizontal()
            stack.spacing = 4
            nodes.append(stack)
            var imageNodes: [ASRatioLayoutSpec] = []
            for _ in result {
                let imageNode = ASNetworkImageNode()
                imageNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor()
                imageNode.style.preferredSize = CGSize(width: 80, height: 80)
                let ratio = ASRatioLayoutSpec(ratio: 1, child: imageNode)
                ratio.style.flexGrow = 1
                node.addSubnode(imageNode)
                imageNodes.append(ratio)
            }
            stack.children = imageNodes
        }
        
        node.layoutSpecBlock = { _, _ in
            let stack = ASStackLayoutSpec.vertical()
            stack.children = nodes
            stack.spacing = 4
            stack.style.minSize = CGSize(width: 248, height: 248)
            
            return ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: stack)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
