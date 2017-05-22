//
//  WBStatusTimelineViewController.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/5/10.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import SwiftyJSON

class WBStatusTimelineViewController: ASViewController<ASTableNode> {

    fileprivate var tableNode: ASTableNode? {
        return node
    }

    fileprivate var datas: [MainModel] = []

    fileprivate var page = -1

    deinit {
        print("WBStatusTimelineViewController 释放")
    }

    init() {
        super.init(node: ASTableNode(style: .plain))
        tableNode?.delegate = self
        tableNode?.dataSource = self
    }

    func insertNewRows(_ n: Int) {
        let section = 0
        var indexPaths = [IndexPath]()

        let newTotalNumberOfPhotos = datas.count - n
        for row in newTotalNumberOfPhotos ..< datas.count {
            let path = IndexPath(row: row, section: section)
            indexPaths.append(path)
        }
        tableNode?.insertRows(at: indexPaths, with: .none)
    }

    func loadPage(with context: ASBatchContext?) {
        page += 1
        if page > 7 {
            page = Int(arc4random_uniform(7))
        }

        guard let path = Bundle.main.path(forResource: "weibo_\(page).json", ofType: "") else {
            return
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return
        }
        let json = JSON(data: data)
        guard let statuses = json.dictionaryValue["statuses"]?.arrayValue else {
            return
        }

        let items = statuses.map { MainModel(data: $0) }
        datas.append(contentsOf: items)

        DispatchQueue.main.async {
            self.insertNewRows(items.count)
            context?.completeBatchFetching(true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "微博"
        view.backgroundColor = kWBCellBackgroundColor
        tableNode?.view.separatorStyle = .none
    }

    override func router(with eventName: String, userInfo: [String: Any]) {
        let message: String
        switch eventName {
        case RouterKeys.likes:
            message = "喜欢"
        case RouterKeys.comments:
            message = "评论"
        case RouterKeys.retweet:
            message = "转发"
        default:
            message = "错误"
        }
        showAlert(message: message)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension WBStatusTimelineViewController: ASTableDataSource {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }

    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            return WeiBoCellNode(item: self.datas[indexPath.row])
        }
    }
}

extension WBStatusTimelineViewController: ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
        context.beginBatchFetching()
        loadPage(with: context)
    }
}

extension UIWindow {
    public var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewController(from: self.rootViewController)
    }

    public static func getVisibleViewController(from vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewController(from: nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewController(from: tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewController(from: pvc)
            } else {
                return vc
            }
        }
    }
}

func showAlert(title: String? = nil, message: String? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "好", style: .default, handler: nil)
    alert.addAction(action)
    let visibleViewController = UIApplication.shared.keyWindow?.visibleViewController
    visibleViewController?.present(alert, animated: true, completion: nil)
}
