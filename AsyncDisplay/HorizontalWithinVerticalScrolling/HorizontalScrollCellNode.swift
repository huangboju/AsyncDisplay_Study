//
//  HorizontalScrollCellNode.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/25.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

private let kOuterPadding: CGFloat = 16.0
private let kInnerPadding: CGFloat = 10.0

class HorizontalScrollCellNode: ASCellNode {
    private var collectionNode: ASCollectionNode!
    fileprivate let elementSize: CGSize
    private var divider: ASDisplayNode!

    init(size: CGSize) {
        self.elementSize = size
        super.init()
        // the containing table uses -nodeForRowAtIndexPath (rather than -nodeBlockForRowAtIndexPath),
        // so this init method will always be run on the main thread (thus it is safe to do UIKit things).
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = elementSize
        flowLayout.minimumInteritemSpacing = kInnerPadding
        

        collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        collectionNode.delegate = self
        collectionNode.dataSource = self
        addSubnode(collectionNode)

        // hairline cell separator
        divider = ASDisplayNode()
        divider.backgroundColor = UIColor.lightGray
        addSubnode(divider)
    }

    // With box model, you don't need to override this method, unless you want to add custom logic.
    override func layout() {
        super.layout()

        collectionNode.view.contentInset = UIEdgeInsetsMake(0.0, kOuterPadding, 0.0, kOuterPadding)

        // Manually layout the divider.
        let pixelHeight = 1.0 / UIScreen.main.scale
        divider.frame = CGRect(x: 0.0, y: 0.0, width: calculatedSize.width, height: pixelHeight);
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let collectionNodeSize = CGSize(width: constrainedSize.max.width, height: elementSize.height)
        collectionNode.style.preferredSize = collectionNodeSize

        return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(kOuterPadding, 0.0, kOuterPadding, 0.0), child: collectionNode)
    }
}

extension HorizontalScrollCellNode: ASCollectionDelegate {
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            let elementNode = RandomCoreGraphicsNode()
            elementNode.style.preferredSize = self.elementSize
            return elementNode
        }
    }
}

extension HorizontalScrollCellNode: ASCollectionDataSource {
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
}
