//
//  RealModel.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/5/11.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//


let screenBounds = UIScreen.main.bounds
let screenW = screenBounds.width
let screenH = screenBounds.height

// 宽高
let kWBCellTopMargin: CGFloat = 8      // cell 顶部灰色留白
let kWBCellTitleHeight: CGFloat = 36   // cell 标题高度 (例如"仅自己可见")
let kWBCellPadding: CGFloat = 12       // cell 内边距
let kWBCellPaddingText: CGFloat = 10   // cell 文本与其他元素间留白
let kWBCellPaddingPic: CGFloat = 4     // cell 多张图片中间留白
let kWBCellProfileHeight: CGFloat = 56 // cell 名片高度
let kWBCellCardHeight: CGFloat = 70    // cell card 视图高度
let kWBCellNamePaddingLeft: CGFloat = 14 // cell 名字和 avatar 之间留白

let kWBCellNameFont = UIFont.systemFont(ofSize: 16)     // 名字字体大小
let kWBCellSourceFont = UIFont.smallSystemFont    // 来源字体大小
let kWBCellTextFont = UIFont.buttonFont     // 文本字体大小
let kWBCellTextFontRetweet = UIFont.labelFont // 转发字体大小
let kWBCellCardTitleFont = UIFont.labelFont // 卡片标题文本字体大小
let kWBCellCardDescFont = UIFont.smallSystemFont // 卡片描述文本字体大小
let kWBCellTitlebarFont = UIFont.systemFont // 标题栏字体大小
let kWBCellToolbarFont = UIFont.systemFont // 工具栏字体大小

// 颜色
let kWBCellNameNormalColor = UIColor(hex: 0x333333) // 名字颜色
let kWBCellNameOrangeColor = UIColor(hex: 0xF26220) // 橙名颜色 (VIP)
let kWBCellTimeNormalColor = UIColor(hex: 0x828282) // 时间颜色
let kWBCellTimeOrangeColor = UIColor(hex: 0xF28824) // 橙色时间 (最新刷出)

let kWBCellTextNormalColor = UIColor(hex: 0x333333) // 一般文本色
let kWBCellTextSubTitleColor = UIColor(hex: 0x5d5d5d) // 次要文本色
let kWBCellTextHighlightColor = UIColor(hex: 0x527ead) // Link 文本色
let kWBCellTextHighlightBackgroundColor = UIColor(hex: 0xbfdffe) // Link 点击背景色
let kWBCellToolbarTitleColor = UIColor(hex: 0x929292) // 工具栏文本色
let kWBCellToolbarTitleHighlightColor = UIColor(hex: 0xdf422d) // 工具栏文本高亮色


let kWBCellBackgroundColor = UIColor(hex: 0xF2F2F2)    // Cell背景灰色
let kWBCellHighlightColor = UIColor(hex: 0xF0F0F0)     // Cell高亮时灰色
let kWBCellInnerViewColor = UIColor(hex: 0xF7F7F7)   // Cell内部卡片灰色
let kWBCellInnerViewHighlightColor =  UIColor(hex: 0xF0F0F0) // Cell内部卡片高亮时灰色
let kWBCellLineColor = UIColor(white: 0, alpha: 0.09) //线条颜色



