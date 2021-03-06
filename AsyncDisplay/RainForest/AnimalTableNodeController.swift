//
//  AnimalTableNodeController.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/20.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import AsyncDisplayKit

class AnimalTableNodeController: ASDKViewController<ASDisplayNode> {
    var animals: [RainforestCardInfo]!
    let tableNode: ASTableNode!

    init(animals: [RainforestCardInfo]) {
        let tableNode = ASTableNode()

        self.animals = animals
        self.tableNode = tableNode

        super.init(node: tableNode)

        tableNode.delegate = self
        tableNode.dataSource = self

        tableNode.view.separatorStyle = .none
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ASTableDelegate

extension AnimalTableNodeController: ASTableDelegate {
    // 该方法在用户滑动到 table 的末端并，且 shouldBatchFetch(for _: ASTableNode) 方法返回 true 时被调用。这个方法不是在主线程
    func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
        nextPageWithCompletion { (results) in
            self.insertNewRows(results)
            context.completeBatchFetching(true)
        }
    }

    // 该方法用于告诉 tableView 是否继续请求新的数据。如果返回 false，则在到达 API 数据末尾时，不会再不会发出任何请求。
    func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
        return true
    }

    // 提供约束尺寸范围，用于测量索引路径上的行。
    func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
        let rect = UIScreen.main.bounds
        let min = CGSize(width: rect.width, height: rect.height/3.0 * 2.0)
        let max = CGSize(width: rect.width, height: CGFloat.greatestFiniteMagnitude)
        return ASSizeRange(min: min, max: max)
    }
}

// MARK: - ASTableDataSource

extension AnimalTableNodeController: ASTableDataSource {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return animals.count
    }

    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let animal = animals[indexPath.row]
        return {
            return CardCellNode(animalInfo: animal)
        }
    }
}

// MARK: - Helpers

extension AnimalTableNodeController {
    func nextPageWithCompletion(_ block: @escaping (_ results: [RainforestCardInfo]) -> ()) {
        let moreAnimals = Array(self.animals[0 ..< 5])
        
        DispatchQueue.main.async {
            block(moreAnimals)
        }
    }

    func insertNewRows(_ newAnimals: [RainforestCardInfo]) {
        let section = 0
        var indexPaths = [IndexPath]()

        let newTotalNumberOfPhotos = animals.count + newAnimals.count

        for row in animals.count ..< newTotalNumberOfPhotos {
            let path = IndexPath(row: row, section: section)
            indexPaths.append(path)
        }

        animals.append(contentsOf: newAnimals)
        tableNode?.insertRows(at: indexPaths, with: .none)
    }
}
