//
//  PagerNodeController.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/26.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class PagerNodeController: ASViewController<ASPagerNode> {
    
    
    init() {
        super.init(node: ASPagerNode())
        
        title = "Pages"
        node.setDataSource(self)

        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(scrollToNextPage))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Previous", style: .plain, target: self, action: #selector(scrollToPreviousPage))
        automaticallyAdjustsScrollViewInsets = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    // MARK: - Actions

    func scrollToNextPage(sender: UIBarButtonItem) {
        node.scrollToPage(at: node.currentPageIndex + 1, animated: true)
    }

    func scrollToPreviousPage(sender: UIBarButtonItem) {
        node.scrollToPage(at: node.currentPageIndex - 1, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension PagerNodeController: ASPagerDataSource {
    func numberOfPages(in pagerNode: ASPagerNode) -> Int {
        return 5
    }

    func pagerNode(_ pagerNode: ASPagerNode, nodeBlockAt index: Int) -> ASCellNodeBlock {
        return {
            let page = PageNode()
            page.backgroundColor = UIColor.random
            return page
        }
    }
}

extension UIColor {
    static var random: UIColor {
        let hue = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness  = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black

        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
}


