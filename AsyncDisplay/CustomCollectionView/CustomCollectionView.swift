//
//  CustomCollectionView.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/24.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class CustomCollectionView: UIViewController, MosaicCollectionViewLayoutDelegate, ASCollectionDataSource, ASCollectionDelegate {

    var sections = [[UIImage]]()
    let collectionNode: ASCollectionNode!
    let _layoutInspector = MosaicCollectionViewLayoutInspector()
    let kNumberOfImages: UInt = 14

    init() {
        let layout = MosaicCollectionViewLayout()
        layout.numberOfColumns = 3
        layout.headerHeight = 44
        collectionNode = ASCollectionNode(frame: CGRect.zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
        layout.delegate = self
        
        sections.append([])
        var section = 0
        for idx in 0 ..< kNumberOfImages {
            let name = String(format: "image_%d.jpg", idx)
            sections[section].append(UIImage(named: name)!)
            if ((idx + 1) % 5 == 0 && idx < kNumberOfImages - 1) {
                section += 1
                sections.append([])
            }
        }

        collectionNode.dataSource = self
        collectionNode.delegate = self
        collectionNode.view.layoutInspector = _layoutInspector
        collectionNode.backgroundColor = UIColor.white
        collectionNode.view.isScrollEnabled = true
        collectionNode.registerSupplementaryNode(ofKind: UICollectionElementKindSectionHeader)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        collectionNode.dataSource = nil
        collectionNode.delegate = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubnode(collectionNode)
    }
    
    override func viewWillLayoutSubviews() {
        collectionNode.frame = view.bounds
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        let image = sections[indexPath.section][indexPath.item]
        return ImageCellNode(with: image)
    }

    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> ASCellNode {
        let textAttributes: [String: Any] = [
            NSFontAttributeName: UIFont.preferredFont(forTextStyle: .headline),
            NSForegroundColorAttributeName: UIColor.gray
        ]
        let textInsets = UIEdgeInsets(top: 11, left: 0, bottom: 11, right: 0)
        let textCellNode = ASTextCellNode(attributes: textAttributes, insets: textInsets)
        textCellNode.text = String(format: "Section %zd", indexPath.section + 1)
        return textCellNode
    }

    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return sections.count
    }

    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return sections[section].count
    }

    func collectionView(_ collectionView: UICollectionView, layout: MosaicCollectionViewLayout, originalItemSizeAtIndexPath: IndexPath) -> CGSize {
        return sections[originalItemSizeAtIndexPath.section][originalItemSizeAtIndexPath.item].size
    }
}
