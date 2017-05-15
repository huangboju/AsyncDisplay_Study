//
//  WBStatus.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/5/15.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import SwiftyJSON

/// 认证方式
enum WBUserVerifyType: Int {
    case none = 0     ///< 没有认证
    case standard     ///< 个人认证，黄V
    case organization ///< 官方认证，蓝V
    case club         ///< 达人认证，红星
}

// MARK: WBStatusToolbarNode

struct ToolBarModel {
    let commtens: Int
    let likes: Int
    let retweetNode: Int
}


// MARK: WBStatusCardNode

struct CardModel {
    let commtens: Int
    let likes: Int
    let retweetNode: Int
}

struct WBURL {
    /**
     链接
     */
//    let result: Bool
    let shortURL: String ///< 短域名 (原文)
//    let oriURL: String   ///< 原始链接
    let urlTitle: String ///< 显示文本，例如"网页链接"，可能需要裁剪(24)
    let urlTypePic: String ///< 链接类型的图片URL
//    let urlType: Int ///< 0:一般链接 36地点 39视频/图片
//    let log: String
//    let actionLog: [String: Any]
    let pageID: String? ///< 对应着 WBPageInfo
//    let storageType: String
    //如果是图片，则会有下面这些，可以直接点开看
//    let picIds: [String]
//    let picInfos: [String: String]
//    let pics: [String]
    
    init(dict: [String: JSON]?) {
        shortURL = dict?["short_url"]?.stringValue ?? ""
        urlTitle = dict?["url_title"]?.stringValue ?? ""
        urlTypePic = dict?["url_type_pic"]?.stringValue ?? ""
        pageID = dict?["page_id"]?.stringValue
    }
}

struct WBUser {
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
    
    let userVerifyType: WBUserVerifyType
    let mbrank: Int ///< 会员等级 (橙名 VIP)
    let avatarLarge: URL     ///< 头像 180*180
    
    init(data: JSON?) {
        let user = data?.dictionaryValue
        
        remark = user?["remark"]?.stringValue ?? ""
        screenName = user?["screen_name"]?.stringValue ?? ""
        name = user?["name"]?.stringValue ?? ""
        
        avatarLarge = (user?["avatar_large"]!.url!)!

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

// MARK: WBStatusTitleNode

struct TitleModel {
    let titleText: NSMutableAttributedString
    let iconURL: URL?
}

// MARK: WBStatusProfileNode

struct ProfileModel {
    let avatarUrl: URL
    let badge: UIImage?
    let name: NSAttributedString
    let source: NSAttributedString
}

struct WBModel {
    var vipUrl: URL?
    var titleModel: TitleModel?
    var profileModel: ProfileModel!
    var toolBarModel: ToolBarModel!
    var text: NSAttributedString!
    var retweetText: NSAttributedString?
    var pics: [URL]?
    
    init(data: JSON) {
        let dict = data.dictionaryValue

        vipUrl = URL(string: WBStatusHelper.formatUrl(with: dict["pic_bg"]?.stringValue))

        let titleDict = dict["title"]?.dictionaryValue
        creatTitleModel(with: titleDict)

        creatProfileModel(with: dict)
        
        // MARK: - toolBarModel
        creatToolBarModel(with: dict)

        text = text(with: dict, isRetweet: false, font: kWBCellTextFont, textColor: kWBCellTextNormalColor)
        
        retweetText = text(with: dict, isRetweet: true, font: kWBCellTextFontRetweet, textColor: kWBCellTextSubTitleColor)
    }
    
    mutating func creatToolBarModel(with dict: [String: JSON]) {
        let commentsCount = dict["comments_count"]?.intValue ?? 0
        let attitudesCount = dict["attitudes_count"]?.intValue ?? 0
        let repostsCount = dict["reposts_count"]?.intValue ?? 0
        toolBarModel = ToolBarModel(commtens: commentsCount, likes: attitudesCount, retweetNode: repostsCount)
    }
    
    // MARK: - titleModel
    mutating func creatTitleModel(with titleDict: [String: JSON]?) {
        guard let text = titleDict?["text"]?.stringValue, let iconURL = titleDict?["icon_url"]?.stringValue else {
            return
        }
        let titleText = NSMutableAttributedString(string: text)
        titleText.addFont(kWBCellTitlebarFont)
        titleText.addForegroundColor(kWBCellToolbarTitleColor)
        
        let link = WBStatusHelper.formatUrl(with: iconURL)
        titleModel = TitleModel(titleText: titleText, iconURL: URL(string: link))
    }
    
    // MARK: - profileModel
    mutating func creatProfileModel(with dict: [String: JSON]) {
        
        let user = WBUser(data: dict["user"])
        
        let remark = user.remark
        let screenName = user.screenName
        let name = user.name
        
        var nameStr: String
        if !remark.isEmpty {
            nameStr = remark
        } else if !screenName.isEmpty {
            nameStr = screenName
        } else {
            nameStr = name
        }
        
        let nameText = NSMutableAttributedString(string: nameStr)
        
        // 蓝V
        if user.userVerifyType == .organization {
            let blueVImage = WBStatusHelper.image(with: "avatar_enterprise_vip")
            let attachment = NSTextAttachment()
            attachment.image = blueVImage
            let blueVText = NSAttributedString(attachment: attachment)
            nameText.append(str: " ")
            nameText.append(blueVText)
        }
        
        // VIP
        if user.mbrank > 0 {
            var yelllowVImage = WBStatusHelper.image(with: "common_icon_membership_level\(user.mbrank)")
            if yelllowVImage == nil {
                yelllowVImage = WBStatusHelper.image(with: "common_icon_membership")
            }
            let attachment = NSTextAttachment()
            attachment.image = yelllowVImage
            let vipText = NSAttributedString(attachment: attachment)
            nameText.append(str: " ")
            nameText.append(vipText)
        }
        
        let color = user.mbrank > 0 ? kWBCellNameOrangeColor : kWBCellNameNormalColor
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byCharWrapping
        nameText.addForegroundColor(color)
        nameText.addFont(kWBCellNameFont)
        nameText.addParagraphStyle(style)
        
        let sourceText = NSMutableAttributedString()
        // TODO: 时间
        let createTime = ""
        // 时间
        if !createTime.isEmpty {
            let timeText = NSMutableAttributedString(string: createTime)
            timeText.append(str: " ")
            timeText.addForegroundColor(kWBCellTimeNormalColor)
            timeText.addFont(kWBCellSourceFont)
            sourceText.append(timeText)
        }
        
        // 来自 XXX
        let source = dict["source"]?.stringValue ?? ""
        if !source.isEmpty {
            // <a href="sinaweibo://customweibosource" rel="nofollow">iPhone 5siPhone 5s</a>
            let hrefRegex = WBStatusHelper.hrefRegex
            let textRegex = WBStatusHelper.textRegex
            
            var href = ""
            var text = ""
            
            let hrefResult = hrefRegex?.firstMatch(in: source, options: [], range: NSRange(location: 0, length: source.length))
            
            let textResult = textRegex?.firstMatch(in: source, options: [], range: NSRange(location: 0, length: source.length))
            
            if let hrefResult = hrefResult, let textResult = textResult, !hrefResult.range.isEmpty , !textResult.range.isEmpty {
                href = source.substr(with: hrefResult.range)
                text = source.substr(with: textResult.range)
            }
            
            if !href.isEmpty && !text.isEmpty {
                let from = NSMutableAttributedString()
                from.append(str: "来自 \(text)")
                from.addFont(kWBCellSourceFont)
                from.addForegroundColor(kWBCellTimeNormalColor)
                let sourceAllowClick = dict["source_allowclick"]?.intValue ?? 0
                if sourceAllowClick > 0 {
                    let range = NSRange(location: 3, length: text.length)
                    from.addForegroundColor(kWBCellTextHighlightColor, range: range)
                }
                
                sourceText.append(from)
            }
        }
        
        var badge: UIImage?
        switch user.userVerifyType {
        case .standard:
            badge = WBStatusHelper.image(with: "avatar_vip")
        case .club:
            badge = WBStatusHelper.image(with: "avatar_grassroot")
        default:  break
        }
        
        profileModel = ProfileModel(avatarUrl: user.avatarLarge, badge: badge, name: nameText, source: sourceText)
    }
    
    // MARK: - Helper
    func text(with dict: [String: JSON], isRetweet: Bool, font: UIFont, textColor: UIColor) -> NSMutableAttributedString {
        var string = dict["text"]?.stringValue ?? ""
        
        let user = WBUser(data: dict["user"])
        if isRetweet {
            var name = user.name
            if name.isEmpty {
                name = user.screenName
            }
            if !name.isEmpty {
                let insert = "@\(name):"
                string = insert + string
            }
        }
        
        // 高亮状态的背景
        //        YYTextBorder *highlightBorder = [YYTextBorder new]
        //        highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0)
        //        highlightBorder.cornerRadius = 3
        //        highlightBorder.fillColor = kWBCellTextHighlightBackgroundColor
        
        let text = NSMutableAttributedString(string: string)
        text.addFont(font)
        text.addForegroundColor(textColor)
        
        //         根据 urlStruct 中每个 URL.shortURL 来匹配文本，将其替换为图标+友好描述
        
        let urls = dict["url_struct"]?.arrayValue.map { WBURL(dict: $0.dictionaryValue)
        }

        guard let urlStruct = urls else {
            return text
        }
        for wburl in urlStruct {
            if wburl.shortURL.isEmpty { continue }
            if wburl.urlTitle.isEmpty { continue }
            var urlTitle = wburl.urlTitle 
            if urlTitle.length > 27 {
                urlTitle = urlTitle.substring(to: 27) + "…"
            }
            var searchRange = NSRange(location: 0, length: text.string.length)
            repeat {
                let range = (text.string as NSString).range(of: wburl.shortURL, options: [], range: searchRange)
                if range.isEmpty { break }
                
                let pageID = dict["page_info"]?.dictionaryValue["page_id"]?.stringValue
                let retweetedStatus = dict["retweeted_status"]?.dictionaryValue
                let pics = dict["pic_infos"]?.dictionaryValue
                
                
                if range.location + range.length == text.length {
                    if let pageID = pageID, let wburlPageID = wburl.pageID, wburlPageID == pageID {
                        if (!isRetweet && retweetedStatus != nil) || isRetweet {
                            if pics == nil {
                                text.replaceCharacters(in: range, with: "")
                                break // cut the tail, show with card
                            }
                        }
                    }
                }
                
                
                
                
                if text.attribute("YYTextHighlight", at: range.location, effectiveRange: nil) == nil {
                    
                    // 替换的内容
                    
                    let replace = NSMutableAttributedString(string: urlTitle)
                    if !wburl.urlTypePic.isEmpty {
                        // 链接头部有个图片附件 (要从网络获取)
                        let picURL = WBStatusHelper.formatUrl(with: wburl.urlTypePic)
                        //                        UIImage *image = [[YYImageCache sharedCache] getImageForKey:picURL.absoluteString]
                        //                        let pic = (image && !wburl.pics.count) ? [self _attachmentWithFontSize:fontSize image:image shrink:YES] : [self _attachmentWithFontSize:fontSize imageURL:wburl.urlTypePic shrink:YES]
                        //                        [replace insertAttributedString:pic atIndex:0]
                    }
                    replace.addFont(font)
                    replace.addForegroundColor(kWBCellTextHighlightColor)
                    
                    // 高亮状态
                    //                    YYTextHighlight *highlight = [YYTextHighlight new]
                    //                    [highlight setBackgroundBorder:highlightBorder]
                    // 数据信息，用于稍后用户点击
                    //                    highlight.userInfo = @{kWBLinkURLName : wburl}
                    //                    [replace setTextHighlight:highlight range:NSMakeRange(0, replace.length)]
                    
                    // 添加被替换的原始字符串，用于复制
                    //                    YYTextBackedString *backed = [YYTextBackedString stringWithString:[text.string substringWithRange:range]]
                    //                    [replace setTextBackedString:backed range:NSMakeRange(0, replace.length)]
                    
                    // 替换
                    text.replaceCharacters(in: range, with: replace)
                    
                    searchRange.location = searchRange.location + max(replace.length, 1)
                    if searchRange.location + 1 >= text.length {
                        break
                    }
                    searchRange.length = text.length - searchRange.location
                } else {
                    searchRange.location = searchRange.location + max(searchRange.length, 1)
                    if searchRange.location + 1 >= text.length {
                        break
                    }
                    searchRange.length = text.length - searchRange.location
                }
            } while true
        }
        
        // 匹配 @用户名
        if let atResults = WBStatusHelper.regexAt?.matches(in: text.string, options: [], range: text.rangeOfAll) {
            for result in atResults {
                if result.range.isEmpty && result.range.length <= 1 { continue }
                if text.attribute("YYTextHighlight", at: result.range.location, effectiveRange: nil) == nil {
                    text.addForegroundColor(kWBCellTextHighlightColor, range: result.range)
                    // 高亮状态
                    //                    YYTextHighlight *highlight = [YYTextHighlight new]
                    //                    [highlight setBackgroundBorder:highlightBorder]
                    //                    // 数据信息，用于稍后用户点击
                    //                    highlight.userInfo = @{kWBLinkAtName : [text.string substringWithRange:NSMakeRange(at.range.location + 1, at.range.length - 1)]}
                    //                    [text setTextHighlight:highlight range:at.range]
                }
            }
        }
        
        // 匹配 [表情]
        
        if let emoticonResults = WBStatusHelper.regexEmoticon?.matches(in: text.string, options: [], range: text.rangeOfAll) {
            var emoClipLength = 0
            for emo in emoticonResults {
                if emo.range.isEmpty && emo.range.length <= 1 { continue }
                var range = emo.range
                range.location -= emoClipLength
                if text.attribute("YYTextHighlight", at: range.location, effectiveRange: nil) != nil { continue }
                if text.attribute("YYTextAttachment", at: range.location, effectiveRange: nil) != nil { continue }
                let emoString = text.string.substr(with: range)
                //                let imagePath = [WBStatusHelper emoticonDic][emoString]
                //                let image = [WBStatusHelper imageWithPath:imagePath]
                //                if image != nil { continue }
                
                
                //                let emoText = [NSAttributedString attachmentStringWithEmojiImage:image fontSize:fontSize]
                //                [text replaceCharactersInRange:range withAttributedString:emoText]
                //                emoClipLength += range.length - 1
            }
        }
        
        return text
    }
}
