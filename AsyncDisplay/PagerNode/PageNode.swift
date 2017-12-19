//
//  PageNode.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/26.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import AsyncDisplayKit

class PageNode: ASCellNode {
    override func calculateSizeThatFits(_ constrainedSize: CGSize) -> CGSize {
        return constrainedSize
    }

    override func didEnterPreloadState() {
        super.didEnterPreloadState()
        print("Fetching data for node: \(self)")
    }
}
