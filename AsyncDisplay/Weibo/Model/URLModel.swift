//
//  URLModel.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/5/17.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import SwiftyJSON

struct URLModel {
    /**
     链接
     */
    //    let result: Bool
    //    let oriURL: String   ///< 原始链接
    //    let urlType: Int ///< 0:一般链接 36地点 39视频/图片
    //    let log: String
    //    let actionLog: [String: Any]
    //    let storageType: String
    //如果是图片，则会有下面这些，可以直接点开看
    //    let picIds: [String]
    //    let picInfos: [String: String]
    let pics: [PictureMetaModel]?
    let pageID: String? ///< 对应着 WBPageInfo
    let urlTitle: String ///< 显示文本，例如"网页链接"，可能需要裁剪(24)
    let urlTypePic: String ///< 链接类型的图片URL
    let shortURL: String ///< 短域名 (原文)

    init(dict: [String: JSON]?) {
        shortURL = dict?["short_url"]?.stringValue ?? ""
        urlTitle = dict?["url_title"]?.stringValue ?? ""
        urlTypePic = dict?["url_type_pic"]?.stringValue ?? ""
        pageID = dict?["page_id"]?.stringValue

        let picInfos = dict?["pic_infos"]?.dictionaryValue
        let picIds = dict?["pic_ids"]?.arrayValue.flatMap { $0.stringValue }

        pics = picIds?.map {
            PictureMetaModel(dict: picInfos?[$0.description]?.dictionaryValue["large"]?.dictionaryValue)
        }
    }
}
