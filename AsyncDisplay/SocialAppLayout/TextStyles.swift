//
//  TextStyles.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/26.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

struct TextStyles {
    static let cellControlColoredStyle: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 13),
        .foregroundColor: UIColor(red: 59.0/255.0, green: 89.0/255.0, blue: 152.0/255.0, alpha: 1)
    ]
    
    static let nameStyle: [NSAttributedString.Key: Any] = [
        .font: UIFont.boldSystemFont(ofSize: 15),
        .foregroundColor: UIColor.black
    ]

    static let usernameStyle: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 13),
        .foregroundColor: UIColor.lightGray
    ]
    
    static let timeStyle: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 13),
        .foregroundColor: UIColor.gray
    ]
    
    static let postStyle: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 15),
        .foregroundColor: UIColor.black
    ]

    static let postLinkStyle: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 15),
        .foregroundColor: UIColor(red: 59.0/255.0, green: 89.0/255.0, blue: 152.0/255.0, alpha: 1),
        .underlineStyle: NSUnderlineStyle.single.rawValue
    ]

    static let cellControlStyle: [NSAttributedString.Key: Any] = [
        .font : UIFont.systemFont(ofSize: 13),
        .foregroundColor: UIColor.lightGray
    ]
}
