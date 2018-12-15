//
//  WBStatus.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/5/15.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import SwiftyJSON
import DateToolsSwift

/// 认证方式
enum UserModelVerifyType: Int {
    case none = 0     ///< 没有认证
    case standard     ///< 个人认证，黄V
    case organization ///< 官方认证，蓝V
    case club         ///< 达人认证，红星
}

/// 卡片类型 (这里随便写的，只适配了微博中常见的类型)
enum WBStatusCardType: Int {
    case none = 0 ///< 没卡片
    case normal   ///< 一般卡片布局
    case video    ///< 视频
}

// MARK: WBStatusToolbarNode

struct ToolBarModel {
    let commtens: (UIImage?, NSAttributedString)
    let likes: (UIImage?, NSAttributedString)
    let retweet: (UIImage?, NSAttributedString)
}


struct MainModel {
    var vipUrl: URL?
    var titleModel: TitleModel?
    var profileModel: ProfileModel!
    var toolBarModel: ToolBarModel!
    var text: NSAttributedString!
    var retweetText: NSAttributedString?
    var pics: [PictureMetaModel]?
    var cardModel: CardModel?

    init(data: JSON) {
        let dict = data.dictionaryValue

        vipUrl = URL(string: WBStatusHelper.formatUrl(with: dict["pic_bg"]?.stringValue))

        let titleDict = dict["title"]?.dictionaryValue
        creatTitleModel(with: titleDict)

        creatProfileModel(with: dict)
        
        // MARK: - toolBarModel
        creatToolBarModel(with: dict)

        text = text(with: dict, isRetweet: false, font: kWBCellTextFont, textColor: kWBCellTextNormalColor)
        createCardModel(with: dict)

        if let retweetedStatus = dict["retweeted_status"]?.dictionaryValue {
            createCardModel(with: retweetedStatus)
            retweetText = text(with: retweetedStatus, isRetweet: true, font: kWBCellTextFontRetweet, textColor: kWBCellTextSubTitleColor)
            pics = PicturesModel(dict: retweetedStatus).pics
        }
    }

    mutating func creatToolBarModel(with dict: [String: JSON]) {
        let commentsCount = dict["comments_count"]?.intValue ?? 0
        let like = dict["attitudes_count"]?.intValue ?? 0
        let repostsCount = dict["reposts_count"]?.intValue ?? 0
        
        let attributes = TextStyles.cellControlStyle

        let comments = (
            WBStatusHelper.image(with: "timeline_icon_comment"),
            NSAttributedString(string: commentsCount > 0 ? "\(commentsCount)" : "评论", attributes: attributes)
        )

        let reposts = (
            WBStatusHelper.image(with: "timeline_icon_retweet"),
            NSAttributedString(string: repostsCount > 0 ? "\(repostsCount)" : "转发", attributes: attributes)
        )

        let likes = (
            WBStatusHelper.image(with: "timeline_icon_unlike"),
            NSAttributedString(string: like > 0 ? "\(like)" : "赞", attributes: attributes)
        )

        toolBarModel = ToolBarModel(commtens: comments, likes: likes, retweet: reposts)
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
        
        let user = UserModel(data: dict["user"])
        
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
        let createTime = dict["created_at"]?.stringValue.formatToTime ?? ""

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
                    from.addLink(URL(string: href)!, range: range)
                }

                sourceText.append(from)
            }
        }

        var badgeName: String?
        switch user.userVerifyType {
        case .standard:
            badgeName = "avatar_vip"
        case .club:
            badgeName = "avatar_grassroot"
        default:  break
        }

        profileModel = ProfileModel(avatarUrl: user.avatarLarge, badgeName: badgeName, name: nameText, source: sourceText)
    }
    
    // MARK: - Helper
    func text(with dict: [String: JSON], isRetweet: Bool, font: UIFont, textColor: UIColor) -> NSMutableAttributedString {
        var string = dict["text"]?.stringValue ?? ""
        
        let user = UserModel(data: dict["user"])
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


        let text = NSMutableAttributedString(string: string)
        text.addFont(font)
        text.addForegroundColor(textColor)

        //         根据 urlStruct 中每个 URL.shortURL 来匹配文本，将其替换为图标+友好描述

        let urls = dict["url_struct"]?.arrayValue.map { URLModel(dict: $0.dictionaryValue)
        }

        if let urlStruct = urls {
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
                    
                    
                    
                    
                    if text.attribute(NSAttributedString.Key(rawValue: "YYTextHighlight"), at: range.location, effectiveRange: nil) == nil {
                        
                        // 替换的内容
                        
                        let replace = NSMutableAttributedString(string: urlTitle)
                        if !wburl.urlTypePic.isEmpty {
                            // 链接头部有个图片附件 (要从网络获取)
                            let picURL = WBStatusHelper.formatUrl(with: wburl.urlTypePic)
                            //                        UIImage *image = [[YYImageCache sharedCache] getImageForKey:picURL.absoluteString]
                            //                        let pic = (image && !wburl.pics.count) ? [self _attachmentWithFontSize:fontSize image:image shrink:YES] : [self _attachmentWithFontSize:fontSize imageURL:wburl.urlTypePic shrink:YES]
                            //                        [replace insertAttributedString:pic atIndex:0]
                            
                        }

                        if let largeImgUrl = wburl.pics?.first?.url {
                            replace.addLink(largeImgUrl)
                        }
                        
                        replace.addFont(font)
                        replace.addForegroundColor(kWBCellTextHighlightColor)

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
        }
        
        
        // 匹配 @用户名
        if let atResults = WBStatusHelper.regexAt?.matches(in: text.string, options: [], range: text.rangeOfAll) {
            for result in atResults {
                let range = result.range
                
                if range.isEmpty && range.length <= 1 { continue }
                
                guard text.attribute(NSAttributedString.Key(rawValue: "YYTextHighlight"), at: range.location, effectiveRange: nil) == nil else  {
                    continue
                }

                text.addForegroundColor(kWBCellTextHighlightColor, range: range)

                let str = text.string.substr(with: NSRange(location: range.location + 1, length: range.length - 1)).encode
                
                text.addLink(URL(string: "http://m.weibo.cn/n/\(str)")!, range: range)
            }
        }
        
        // 匹配 [表情]
        if let emoticonResults = WBStatusHelper.regexEmoticon?.matches(in: text.string, options: [], range: text.rangeOfAll) {
            var emoClipLength = 0
            for emo in emoticonResults {
                if emo.range.isEmpty && emo.range.length <= 1 { continue }
                var range = emo.range
                range.location -= emoClipLength
                if text.attribute(NSAttributedString.Key(rawValue: "YYTextHighlight"), at: range.location, effectiveRange: nil) != nil { continue }
                if text.attribute(NSAttributedString.Key(rawValue: "YYTextAttachment"), at: range.location, effectiveRange: nil) != nil { continue }
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
    
    mutating func createCardModel(with status: [String: JSON]) {
        guard let dict = status["page_info"]?.dictionary else { return }

        let pageInfo = PageInfoModel(dict: dict)
        
        var cardType: WBStatusCardType = .none

        if pageInfo.type == 11 && pageInfo.objectType == "video" {
            // 视频，一个大图片，上面播放按钮
            if pageInfo.pagePic != nil {
                cardType = .video
            }
        } else {

            let text = NSMutableAttributedString()
            
            let wrap = {
                if !text.isEmpty {
                    text.append(str: "\n")
                }
            }

            if !pageInfo.pageTitle.isEmpty {
                let title = NSMutableAttributedString(string: pageInfo.pageTitle)
                title.addFont(kWBCellCardTitleFont)
                title.addForegroundColor(kWBCellNameNormalColor)
                text.append(title)
            }

            if !pageInfo.pageDesc.isEmpty {
                wrap()
                let desc = NSMutableAttributedString(string: pageInfo.pageDesc)
                desc.addFont(kWBCellCardDescFont)
                desc.addForegroundColor(kWBCellNameNormalColor)
                text.append(desc)
            } else if !pageInfo.content2.isEmpty {
                wrap()
                let content2 = NSMutableAttributedString(string: pageInfo.content2)
                content2.addFont(kWBCellCardDescFont)
                content2.addForegroundColor(kWBCellTextSubTitleColor)
                text.append(content2)
            } else if !pageInfo.content3.isEmpty {
                wrap()
                let content3 = NSMutableAttributedString(string: pageInfo.content3)
                content3.addFont(kWBCellCardDescFont)
                content3.addForegroundColor(kWBCellTextSubTitleColor)
                text.append(content3)
            }

            if !pageInfo.tips.isEmpty {
                wrap()
                let tips = NSMutableAttributedString(string: pageInfo.tips)
                tips.addFont(kWBCellCardDescFont)
                tips.addForegroundColor(kWBCellTextSubTitleColor)
                text.append(tips)
            }

            if !text.isEmpty {
                let style =  NSMutableParagraphStyle()
                style.maximumLineHeight = 20
                style.minimumLineHeight = 20
                style.lineBreakMode = .byTruncatingTail
                text.addParagraphStyle(style)

            }
            cardModel = CardModel(picUrl: pageInfo.pagePic, badgeUrl: pageInfo.typeIcon, text: text)
        }
    }
}
