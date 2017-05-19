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
        let bmiddleDict = dict?["bmiddle"]?.dictionaryValue
        cutType = bmiddleDict?["cut_type"]?.intValue ?? 0
        type = bmiddleDict?["type"]?.stringValue ?? ""
        url = (bmiddleDict?["url"]?.url)!
        width = bmiddleDict?["width"]?.doubleValue ?? 0
        height = bmiddleDict?["height"]?.doubleValue ?? 0
        croped = bmiddleDict?["croped"]?.boolValue ?? false
        if type == "GIF" {
            badgeName = "timeline_image_gif"
        } else if width > 0 && height / width > 3  {
            badgeName = "timeline_image_longimage"
        }
    }
}
