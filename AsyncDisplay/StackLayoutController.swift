//
//  PromiseKitController.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/5/18.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class StackLayoutController: ASViewController<ASDisplayNode> {
    
    init() {
        super.init(node: ASDisplayNode())
        let node1 = ASDisplayNode()
//        node1.style.preferredSize = CGSize(width: 100, height: 20)
        node1.style.flexBasis = ASDimensionMakeWithFraction(0.4)
//        node1.style.height = ASDimensionMakeWithPoints(40)
        node1.backgroundColor = .red
        node.addSubnode(node1)
        
        let node2 = ASDisplayNode()
//        node2.style.preferredSize = CGSize(width: 30, height: 40)
        node2.style.flexBasis = ASDimensionMakeWithFraction(0.6)
//        node2.style.height = ASDimensionMakeWithPoints(40)
        node2.backgroundColor = .green
        node.addSubnode(node2)
        
//        let node3 = ASDisplayNode()
//        node3.style.preferredSize = CGSize(width: 40, height: 100)
//        node3.backgroundColor = .blue
//        node3.style.alignSelf = .end
//        node.addSubnode(node3)
        
        node.layoutSpecBlock = { _, _ in
            
            let stack = ASStackLayoutSpec.horizontal()
            stack.children = [node1, node2]
            stack.alignItems = .center
            stack.style.preferredSize = CGSize(width: 100, height: 100)
            
//            let stack = ASStackLayoutSpec.horizontal()
//            stack.verticalAlignment = .center
//            stack.children = [node1, node2, node3]

            return ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: stack)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
