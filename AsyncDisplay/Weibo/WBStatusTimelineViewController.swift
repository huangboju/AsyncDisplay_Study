//
//  WBStatusTimelineViewController.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/5/10.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import SwiftyJSON

class WBStatusTimelineViewController: ASViewController<ASTableNode> {
    
    fileprivate var tableNode: ASTableNode!
    
    fileprivate var datas: [MainModel] = []

    fileprivate var page = -1

    deinit {
        print("WBStatusTimelineViewController 释放")
    }

    init() {
        tableNode = ASTableNode(style: .plain)
        super.init(node: tableNode)
        tableNode.delegate = self
        tableNode.dataSource = self
    }

    func insertNewRows(_ n: Int) {
        let section = 0
        var indexPaths = [IndexPath]()

        let newTotalNumberOfPhotos = datas.count - n
        for row in newTotalNumberOfPhotos ..< datas.count {
            let path = IndexPath(row: row, section: section)
            indexPaths.append(path)
        }
        tableNode.insertRows(at: indexPaths, with: .none)
    }

    func loadPage(with context: ASBatchContext?) {
        page += 1
        page = min(7, page)
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
        tableNode.view.separatorStyle = .none
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
