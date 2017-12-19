//
//  ASCollectionView.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/19.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import AsyncDisplayKit

class ASCollectionViewController: UIViewController {
    
    private lazy var collectionNode: ASCollectionNode = {
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: 50.0, height: 50.0)
        layout.footerReferenceSize = CGSize(width: 50.0, height: 50.0)

        let collectionNode = ASCollectionNode(frame: self.view.bounds, collectionViewLayout: layout)
        collectionNode.registerSupplementaryNode(ofKind: UICollectionElementKindSectionHeader)
        collectionNode.registerSupplementaryNode(ofKind: UICollectionElementKindSectionFooter)
        collectionNode.dataSource = self
        collectionNode.delegate = self

        collectionNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionNode.backgroundColor = UIColor.white

        return collectionNode
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubnode(collectionNode)
        collectionNode.frame = view.bounds
    }

    deinit {
        collectionNode.dataSource = nil
        collectionNode.delegate = nil
    }
}

extension ASCollectionViewController: ASCollectionDataSource {
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let text = "[\(indexPath.section).\(indexPath.item)] says hi"
        return {
            return ItemNode(string: text)
        }
    }

    func collectionNode(_ collectionNode: ASCollectionNode, nodeForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> ASCellNode {
        let text = kind == UICollectionElementKindSectionHeader ? "Header" : "Footer"
        let node = SupplementaryNode(text: text)
        let isHeaderSection = kind == UICollectionElementKindSectionHeader
        node.backgroundColor = isHeaderSection ? UIColor.blue : UIColor.red
        return node
    }

    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 100
    }

    func collectionNode(_ collectionNode: ASCollectionNode, willBeginBatchFetchWith context: ASBatchContext) {
        context.completeBatchFetching(true)
    }
}

extension ASCollectionViewController: ASCollectionDelegate {

}
