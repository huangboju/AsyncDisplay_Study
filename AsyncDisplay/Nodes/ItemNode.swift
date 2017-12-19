//
//  ItemNode.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/19.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import AsyncDisplayKit

class ItemNode: ASTextCellNode {
    init(string: String) {
        super.init()
        text = string
        updateBackgroundColor()
    }

    override var isSelected: Bool {
        didSet {
            updateBackgroundColor()
        }
    }

    override var isHighlighted: Bool {
        didSet {
            updateBackgroundColor()
        }
    }
    
    func updateBackgroundColor() {
        if isHighlighted {
            backgroundColor = UIColor.gray
        } else if isSelected {
            backgroundColor = UIColor.darkGray
        } else {
            backgroundColor = UIColor.lightGray
        }
    }
}
