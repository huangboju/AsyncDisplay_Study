//
//  WBPageInfo.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/5/17.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import SwiftyJSON

struct PageInfoModel {
    let pageTitle: String ///< 页面标题，例如"上海·上海文庙"
    let pageDesc: String ///< 页面描述，例如"上海市黄浦区文庙路215号"
    let content1: String
    let content2: String
    let content3: String
    let content4: String
    let tips: String ///< 提示，例如"4222条微博"
    let objectType: String ///< 类型，例如"place" "video"
    let type: Int
    let pagePic: URL? ///< 图片URL，不需要加(_default) 通常是左侧的方形图片
    let typeIcon: URL? ///< Badge 图片URL，不需要加(_default) 通常放在最左上角角落里
    let buttons: [ButtonLinkModel]?

//    let objectID: String
//    let pageID: String
//    let scheme: String ///< 真实链接，例如 http://v.qq.com/xxx
//    let isAsyn: Int
//    let pageURL: String ///< 链接 sinaweibo://...
//    let actStatus: Int
//    let actionlog: [String: Any]
//    let mediaInfo: [String: Any]

    init(dict: [String: JSON]) {
        pageTitle = dict["page_title"]?.stringValue ?? ""
        pageDesc = dict["page_desc"]?.stringValue ?? ""
        content1 = dict["content1"]?.stringValue ?? ""
        content2 = dict["content2"]?.stringValue ?? ""
        content3 = dict["content3"]?.stringValue ?? ""
        content4 = dict["content4"]?.stringValue ?? ""
        type = dict["type"]?.intValue ?? 0
        objectType = dict["object_type"]?.stringValue ?? ""
        pagePic = dict["page_pic"]?.url
        typeIcon = dict["type_icon"]?.url
        tips = dict["tips"]?.stringValue ?? ""
        buttons = dict["buttons"]?.arrayValue.map { ButtonLinkModel(dict: $0.dictionaryValue) }
    }
}
