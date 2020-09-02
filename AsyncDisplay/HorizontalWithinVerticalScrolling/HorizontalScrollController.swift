//
//  HorizontalScrollController.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/25.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import AsyncDisplayKit

class HorizontalScrollController: ASDKViewController<ASDisplayNode> {
    
    var tableNode: ASTableNode!
    
    override init() {
        tableNode = ASTableNode(style: .plain)
        super.init(node: tableNode)
        tableNode.dataSource = self
        tableNode.delegate = self
        title = "Horizontal Scrolling Gradients"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableNode.view.separatorStyle = .none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HorizontalScrollController: ASTableDataSource {
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        return HorizontalScrollCellNode(size: CGSize(width: 100, height: 100))
    }

    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
}

extension HorizontalScrollController: ASTableDelegate {

}
