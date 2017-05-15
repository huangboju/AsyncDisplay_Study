//
//  ASCollectionView.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/19.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class ASCollectionViewController: UIViewController {
    
    var collectionNode: ASCollectionNode!

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 10, height: 10)

        collectionNode = ASCollectionNode(frame: .zero, collectionViewLayout: layout, layoutFacilitator: nil)

        collectionNode.dataSource = self
        collectionNode.delegate = self

        collectionNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionNode.backgroundColor = UIColor.white

        view.addSubnode(collectionNode)
        collectionNode.frame = view.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        collectionNode.dataSource = nil
        collectionNode.delegate = nil
    }
}

extension ASCollectionViewController: ASCollectionDataSource {
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> ASCellNodeBlock {
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
