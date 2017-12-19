//
//  LinkManager.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/5/22.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import AsyncDisplayKit

class LinkManager: NSObject, ASTextNodeDelegate {

    func textNode(_ textNode: ASTextNode, shouldHighlightLinkAttribute attribute: String, value: Any, at point: CGPoint) -> Bool {
        return true
    }

    func textNode(_ textNode: ASTextNode, tappedLinkAttribute attribute: String, value: Any, at point: CGPoint, textRange: NSRange) {
        guard let url = value as? URL else {
            showAlert(message: (value as? String) ?? "")
            return
        }
        guard UIApplication.shared.canOpenURL(url) else {
            showAlert(message: url.absoluteString)
            return
        }
        
        
        let visibleViewController = UIApplication.shared.keyWindow?.visibleViewController
        visibleViewController?.navigationController?.pushViewController(WebController(url: url), animated: true)
    }
}
