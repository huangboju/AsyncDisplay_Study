//
//  UserModel.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/5/17.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import SwiftyJSON

struct UserModel {
    //    let userID: Int ///< id (int)
    //    let idString: String ///< id (string)
    //    let gender: Int /// 0:none 1:男 2:女
    //    let genderString: String /// "m":男 "f":女 "n"未知
    //    let desc: String ///< 个人简介
    //    let domain: String ///< 个性域名
    //    let followersCount: Int ///< 粉丝数
    //    let friendsCount: Int ///< 关注数
    //    let biFollowersCount: Int ///< 好友数 (双向关注)
    //    let favouritesCount: Int ///< 收藏数
    //    let statusesCount: Int ///< 微博数
    //    let topicsCount: Int ///< 话题数
    //    let blockedCount: Int ///< 屏蔽数
    //    let pagefriendsCount: Int
    //    let followMe: Bool
    //    let followingL: Bool
    //
    //    let province: String ///< 省
    //    let city: String    ///< 市
    //
    //    let url: String ///< 博客地址
    //    let profileImageURL: URL ///< 头像 50x50 (FeedList)
    
    //    let avatarHD: URL        ///< 头像 原图
    //    let coverImage: URL      ///< 封面图 920x300
    //    let coverImagePhone: URL
    //
    //    let profileURL: String
    //    let type: Int
    //    let ptype: Int
    //    let mbtype: Int
    //    let urank: Int ///< 微博等级 (LV)
    //    let uclass: Int
    //    let ulevel: Int
    
    //    let star: Int
    //    let level: Int
    //    let createdAt: Date ///< 注册时间
    //    let allowAllActMsg: Bool
    //    let allowAllComment: Bool
    //    let geoEnabled: Bool
    //    let onlineStatus: Int
    //    let location: String ///< 所在地
    //    let icons: [[String: String]]
    //    let weihao: String
    //    let badgeTop: String
    //    let blockWord: Int
    //    let blockApp: Int
    //    let hasAbilityTag: Int
    //    let creditScore: Int ///< 信用积分
    //    let badge: [String: Int] ///< 勋章
    //    let lang: String
    //    let userAbility: Int
    //    let extend: [String: Any]
    //
    //    let verified: Bool ///< 微博认证 (大V)
    //    let verifiedType: Int
    //    let verifiedLevel: Int
    //    let verifiedState: Int
    //    let verifiedContactEmail: String
    //    let verifiedContactMobile: String
    //    let verifiedTrade: String
    //    let verifiedContactName: String
    //    let verifiedSource: String
    //    let verifiedSourceURL: String
    //    let verifiedReason: String ///< 微博认证描述
    //    let verifiedReasonURL: String
    //    let verifiedReasonModified: String
    
    let name: String ///< 昵称
    let screenName: String ///< 友好昵称
    let remark: String ///< 备注
    
    let userVerifyType: UserModelVerifyType
    let mbrank: Int ///< 会员等级 (橙名 VIP)
    let avatarLarge: URL?     ///< 头像 180*180
    
    init(data: JSON?) {
        let user = data?.dictionaryValue
        
        remark = user?["remark"]?.stringValue ?? ""
        screenName = user?["screen_name"]?.stringValue ?? ""
        name = user?["name"]?.stringValue ?? ""
        
        avatarLarge = user?["avatar_large"]?.url
        
        mbrank = user?["mbrank"]?.intValue ?? 0
        
        let verified = user?["verified"]?.boolValue ?? false
        let verifiedType = user?["verified_type"]?.intValue ?? 0
        let verifiedLevel = user?["verified_level"]?.intValue ?? 0
        if verified {
            userVerifyType = .standard
        } else if verifiedType == 220 {
            userVerifyType = .club
        } else if verifiedType == -1 && verifiedLevel == 3 {
            userVerifyType = .organization
        } else {
            userVerifyType = .none
        }
    }
}
