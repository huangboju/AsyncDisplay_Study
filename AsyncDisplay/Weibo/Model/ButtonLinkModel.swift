//
//  ButtonLinkModel.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/5/17.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import SwiftyJSON

struct ButtonLinkModel {
    let pic: URL?  ///< 按钮图片URL (需要加_default)
    let name: String ///< 按钮文本，例如"点评"
    let type: String
//    let params: [String: Any]
    
    init(dict: [String: JSON]) {
        pic = dict["pic"]?.url
        name = dict["name"]?.stringValue ?? ""
        type = dict["type"]?.stringValue ?? ""
    }
}
