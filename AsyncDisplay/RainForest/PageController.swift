//
//  PageController.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/20.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import AsyncDisplayKit

class PageController: UIViewController {
    let pagerNode = ASPagerNode()
    let allAnimals = [
        RainforestCardInfo.birdCards(),
        RainforestCardInfo.mammalCards(),
        RainforestCardInfo.reptileCards()
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pagerNode.setDataSource(self)

        view.addSubnode(pagerNode)

        automaticallyAdjustsScrollViewInsets = false
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        pagerNode.frame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64)
    }
}

// MARK: - ASPagerDataSource

extension PageController: ASPagerDataSource {
    func pagerNode(_ pagerNode: ASPagerNode, nodeAt index: Int) -> ASCellNode {
        let animals = allAnimals[index]

        let node = ASCellNode(viewControllerBlock: { () -> UIViewController in
            return AnimalTableNodeController(animals: animals!)
        }, didLoad: nil)
        
        return node
    }
    
    func numberOfPages(in pagerNode: ASPagerNode) -> Int {
        return allAnimals.count
    }
}
