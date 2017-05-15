//
//  WBModel.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/5/10.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

/// 认证方式
enum WBUserVerifyType {
    case none          ///< 没有认证
    case standard      ///< 个人认证，黄V
    case organization  ///< 官方认证，蓝V
    case club          ///< 达人认证，红星
}


/// 图片标记
enum WBPictureBadgeType {
    case none      ///< 正常图片
    case long      ///< 长图
    case gif       ///< GIF
}


/**
 一个图片的元数据
 */
struct WBPictureMetadata {
    let url: URL ///< Full image url
    let width: Int ///< pixel width
    let height: Int ///< pixel height
    let type: String ///< "WEBP" "JPEG" "GIF"
    let cutType: Int ///< Default:1
    let badgeType: WBPictureBadgeType
}


/**
 图片
 */
struct WBPicture {
    let picID: String
    let objectID: String
    let photoTag: Int
    let keepSize: Bool ///< YES:固定为方形 NO:原始宽高比
    let thumbnail: WBPictureMetadata  ///< w:180
    let bmiddle: WBPictureMetadata    ///< w:360 (列表中的
    let middlePlus: WBPictureMetadata ///< w:480
    let large: WBPictureMetadata      ///< w:720 (放大查看)
    let largest: WBPictureMetadata    ///<       (查看原图)
    let original: WBPictureMetadata   ///<
    let badgeType: WBPictureBadgeType
}


/**
 链接
 */
struct WBURL {
    let result: Bool
    let shortURL: String ///< 短域名 (原文)
    let oriURL: String   ///< 原始链接
    let urlTitle: String ///< 显示文本，例如"网页链接"，可能需要裁剪(24)
    let urlTypePic: String ///< 链接类型的图片URL
    let urlType: Int ///< 0:一般链接 36地点 39视频/图片
    let log: String
    let actionLog: [String: Any]
    let pageID: String ///< 对应着 WBPageInfo
    let storageType: String
    //如果是图片，则会有下面这些，可以直接点开看
    let picIds: [String]
    let picInfos: [String: WBPicture]
    let pics: [WBPicture]
}


/**
 话题
 */
struct WBTopic {
    let topicTitle: String  ///< 话题标题
    let topicURL: String    ///< 话题链接 sinaweibo://
}


/**
 标签
 */
struct WBTag {
    let tagName: String ///< 标签名字，例如"上海·上海文庙"
    let tagScheme: String ///< 链接 sinaweibo://...
    let tagType: Int ///< 1 地点 2其他
    let tagHidden: Int
    let urlTypePic: URL ///< 需要加 _default
}


/**
 按钮
 */
struct WBButtonLink {
    let pic: URL  ///< 按钮图片URL (需要加_default)
    let name: String ///< 按钮文本，例如"点评"
    let type: String
    let params: [String: Any]
}


/**
 卡片 (样式有多种，最常见的是下方这样)
 -----------------------------
 title
 pic     title        button
 tips
 -----------------------------
 */
struct WBPageInfo {
    let pageTitle: String ///< 页面标题，例如"上海·上海文庙"
    let pageID: String
    let pageDesc: String ///< 页面描述，例如"上海市黄浦区文庙路215号"
    let content1: String
    let content2: String
    let content3: String
    let content4: String
    let tips: String ///< 提示，例如"4222条微博"
    let objectType: String ///< 类型，例如"place" "video"
    let objectID: String
    let scheme: String ///< 真实链接，例如 http://v.qq.com/xxx
    let buttons: [WBButtonLink]
    
    let isAsyn: Int
    let type: Int
    let pageURL: String ///< 链接 sinaweibo://...
    let pagePic: URL ///< 图片URL，不需要加(_default) 通常是左侧的方形图片
    let typeIcon: URL ///< Badge 图片URL，不需要加(_default) 通常放在最左上角角落里
    let actStatus: Int
    let actionlog: [String: Any]
    let mediaInfo: [String: Any]
}


/**
 微博标题
 */
struct WBStatusTitle {
    let baseColor: Int
    let text: String ///< 文本，例如"仅自己可见"
    let iconURL: String ///< 图标URL，需要加Default
}


/**
 用户
 */
struct WBUser {
    let userID: Int ///< id (int)
    let idString: String ///< id (string)
    let gender: Int /// 0:none 1:男 2:女
    let genderString: String /// "m":男 "f":女 "n"未知
    let desc: String ///< 个人简介
    let domain: String ///< 个性域名
    
    let name: String ///< 昵称
    let screenName: String ///< 友好昵称
    let remark: String ///< 备注
    
    let followersCount: Int ///< 粉丝数
    let friendsCount: Int ///< 关注数
    let biFollowersCount: Int ///< 好友数 (双向关注)
    let favouritesCount: Int ///< 收藏数
    let statusesCount: Int ///< 微博数
    let topicsCount: Int ///< 话题数
    let blockedCount: Int ///< 屏蔽数
    let pagefriendsCount: Int
    let followMe: Bool
    let following: Bool
    
    let province: String ///< 省
    let city: String     ///< 市
    
    let url: String ///< 博客地址
    let profileImageURL: URL ///< 头像 50x50 (FeedList)
    let avatarLarge: URL     ///< 头像 180*180
    let avatarHD: URL        ///< 头像 原图
    let coverImage: URL      ///< 封面图 920x300
    let coverImagePhone: URL
    
    let profileURL: String
    let type: Int
    let ptype: Int
    let mbtype: Int
    let urank: Int ///< 微博等级 (LV)
    let uclass: Int
    let ulevel: Int
    let mbrank: Int ///< 会员等级 (橙名 VIP)
    let star: Int
    let level: Int
    let createdAt: Date ///< 注册时间
    let allowAllActMsg: Bool
    let allowAllComment: Bool
    let geoEnabled: Bool
    let onlineStatus: Int
    let location: String ///< 所在地
    let icons: [[String: String]]
    let weihao: String
    let badgeTop: String
    let blockWord: Int
    let blockApp: Int
    let hasAbilityTag: Int
    let creditScore: Int ///< 信用积分
    let badge: [String: Int] ///<
    let lang: String
    let userAbility: Int
    let extend: [String: Any]
    
    let verified: Bool ///< 微博认证 (大V)
    let verifiedType: Int
    let verifiedLevel: Int
    let verifiedState: Int
    let verifiedContactEmail: String
    let verifiedContactMobile: String
    let verifiedTrade: String
    let verifiedContactName: String
    let verifiedSource: String
    let verifiedSourceURL: String
    let verifiedReason: String ///< 微博认证描述
    let verifiedReasonURL: String
    let verifiedReasonModified: String
    
    let userVerifyType: WBUserVerifyType
}

/**
 微博
 */
struct WBStatus {
    let statusID: Int ///< id (number)
    let idstr: String ///< id (string)
    let mid: String
    let rid: String
    let createdAt: Date ///< 发布时间
    
    let user: WBUser
    let userType: Int
    
    let title: WBStatusTitle ///< 标题栏 (通常为nil)
    let picBg: String ///< 微博VIP背景图，需要替换 "os7"
    let text: String ///< 正文
    let thumbnailPic: URL ///< 缩略图
    let bmiddlePic: URL ///< 中图
    let originalPic: URL ///< 大图

//    let retweetedStatus: WBStatus ///转发微博
    
    let picIds: [String]
    let picInfos: [String: WBPicture]
    
    let pics: [WBPicture]
    let urlStruct: [WBURL]
    let topicStruct: [WBTopic]
    let tagStruct: [WBTag]
    let pageInfo: WBPageInfo
    
    let favorited: Bool ///< 是否收藏
    let truncated: Bool  ///< 是否截断
    let repostsCount: Int ///< 转发数
    let commentsCount: Int ///< 评论数
    let attitudesCount: Int ///< 赞数
    let attitudesStatus: Int ///< 是否已赞 0:没有
    let recomState: Int
    
    let inReplyToScreenName: String
    let inReplyToStatusId: String
    let inReplyToUserId: String
    
    let source: String ///< 来自 XXX
    let sourceType: Int
    let sourceAllowClick: Int ///< 来源是否允许点击
    
    let geo: [String: Any]
    let annotations: [String] ///< 地理位置
    let bizFeature: Int
    let mlevel: Int
    let mblogid: String
    let mblogTypeName: String
    let scheme: String
    let visible: [String: Any]
    let darwinTags: [String]
}

/**
 一次API请求的数据
 */
struct WBTimelineItem {
    let ad: [String]
    let advertises: [String]
    let gsid: String
    let interval: Int
    let uveBlank: Int
    let hasUnread: Int
    let totalNumber: Int
    let sinceID: String
    let maxID: String
    let previousCursor: String
    let nextCursor: String
    let statuses: [WBStatus]
    /*
     groupInfo
     trends
     */
}
