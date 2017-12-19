//
//  PicturesModel.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/5/17.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import SwiftyJSON

struct PicturesModel {
    let pics: [PictureMetaModel]?
    
    init(dict: [String: JSON]) {
        let picIds: [String]? = dict["pic_ids"]?.arrayValue.flatMap { $0.stringValue }

        let picInfos = dict["pic_infos"]?.dictionaryValue

        pics = picIds?.map {
            PictureMetaModel(dict: picInfos?[$0]?.dictionaryValue["bmiddle"]?.dictionaryValue)
        }
    }
}
