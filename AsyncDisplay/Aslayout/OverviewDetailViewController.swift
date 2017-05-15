//
//  OverviewDetailViewController.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/21.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class OverviewDetailViewController: UIViewController {
    
    var node: ASDisplayNode!
    
    init(node: ASDisplayNode) {
        super.init(nibName: nil, bundle: nil)
        self.node = node
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        view.addSubnode(node)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Center node frame
        let bounds = view.bounds

        let nodeSize = node.layoutThatFits(ASSizeRangeMake(.zero, bounds.size)).size
        node.frame = CGRect(
            x: bounds.midX - (nodeSize.width / 2.0),
            y: bounds.midY - (nodeSize.height / 2.0),
            width: nodeSize.width,
            height: nodeSize.height
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
