//
//  PictureMetaModel.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/5/17.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import SwiftyJSON

struct PictureMetaModel {
    let cutType: Int
    let type: String // "WEBP" "JPEG" "GIF"
    let url: URL
    let width: Double
    let height: Double
    let croped: Bool
    var badgeName: String?

    init(dict: [String: JSON]?) {

        cutType = dict?["cut_type"]?.intValue ?? 0
        type = dict?["type"]?.stringValue ?? ""
        url = dict?["url"]?.url ?? URL(string: "https://www.baidu.com/")!
        width = dict?["width"]?.doubleValue ?? 0
        height = dict?["height"]?.doubleValue ?? 0
        croped = dict?["croped"]?.boolValue ?? false
        if type == "GIF" {
            badgeName = "timeline_image_gif"
        } else if width > 0 && height / width > 3  {
            badgeName = "timeline_image_longimage"
        }
    }
}
