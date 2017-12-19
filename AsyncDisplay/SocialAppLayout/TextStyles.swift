//
//  TextStyles.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/26.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

struct TextStyles {
    static let cellControlColoredStyle: [NSAttributedStringKey: Any] = [
        .font: UIFont.systemFont(ofSize: 13),
        .foregroundColor: UIColor(red: 59.0/255.0, green: 89.0/255.0, blue: 152.0/255.0, alpha: 1)
    ]
    
    static let nameStyle: [NSAttributedStringKey: Any] = [
        .font: UIFont.boldSystemFont(ofSize: 15),
        .foregroundColor: UIColor.black
    ]

    static let usernameStyle: [NSAttributedStringKey: Any] = [
        .font: UIFont.systemFont(ofSize: 13),
        .foregroundColor: UIColor.lightGray
    ]
    
    static let timeStyle: [NSAttributedStringKey: Any] = [
        .font: UIFont.systemFont(ofSize: 13),
        .foregroundColor: UIColor.gray
    ]
    
    static let postStyle: [NSAttributedStringKey: Any] = [
        .font: UIFont.systemFont(ofSize: 15),
        .foregroundColor: UIColor.black
    ]

    static let postLinkStyle: [NSAttributedStringKey: Any] = [
        .font: UIFont.systemFont(ofSize: 15),
        .foregroundColor: UIColor(red: 59.0/255.0, green: 89.0/255.0, blue: 152.0/255.0, alpha: 1),
        .underlineStyle: NSUnderlineStyle.styleSingle.rawValue
    ]

    static let cellControlStyle: [NSAttributedStringKey: Any] = [
        .font : UIFont.systemFont(ofSize: 13),
        .foregroundColor: UIColor.lightGray
    ]
}
