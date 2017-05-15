//
//  TextStyles.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/26.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

struct TextStyles {
    static let cellControlColoredStyle: [String: Any] = [
        NSFontAttributeName: UIFont.systemFont(ofSize: 13),
        NSForegroundColorAttributeName: UIColor(red: 59.0/255.0, green: 89.0/255.0, blue: 152.0/255.0, alpha: 1)
    ]
    
    static let nameStyle: [String: Any] = [
        NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15),
        NSForegroundColorAttributeName: UIColor.black
    ]

    static let usernameStyle: [String: Any] = [
        NSFontAttributeName: UIFont.systemFont(ofSize: 13),
        NSForegroundColorAttributeName: UIColor.lightGray
    ]
    
    static let timeStyle: [String: Any] = [
        NSFontAttributeName: UIFont.systemFont(ofSize: 13),
        NSForegroundColorAttributeName: UIColor.gray
    ]
    
    static let postStyle: [String: Any] = [
        NSFontAttributeName: UIFont.systemFont(ofSize: 15),
        NSForegroundColorAttributeName: UIColor.black
    ]

    static let postLinkStyle: [String: Any] = [
        NSFontAttributeName: UIFont.systemFont(ofSize: 15),
        NSForegroundColorAttributeName: UIColor(red: 59.0/255.0, green: 89.0/255.0, blue: 152.0/255.0, alpha: 1),
        NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue
    ]

    static let cellControlStyle: [String: Any] = [
        NSFontAttributeName : UIFont.systemFont(ofSize: 13),
        NSForegroundColorAttributeName: UIColor.lightGray
    ]
}
