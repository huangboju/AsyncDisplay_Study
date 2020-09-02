//
//  KittensController.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/25.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

private let kLitterSize = 20           // intial number of kitten cells in ASTableNode
private let kLitterBatchSize = 10      // number of kitten cells to add to ASTableNode
private let kMaxLitterSize = 100       // max number of kitten cells allowed in ASTableNode

import AsyncDisplayKit

class KittensController: ASDKViewController<ASDisplayNode> {
    
    var tableNode: ASTableNode!
    
    lazy var kittenDataSource: [CGSize] = []

    var blurbNodeIndexPath = IndexPath(row: 0, section: 0)

    override init() {
        tableNode = ASTableNode(style: .plain)
        super.init(node: tableNode)

        tableNode.dataSource = self
        tableNode.delegate = self

        // populate our "data source" with some random kittens
        kittenDataSource = createLitter(with: kLitterSize)
        
        
        title = "Kittens"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableNode.view.separatorStyle = .none
    }
    
    func createLitter(with size: Int) -> [CGSize] {
        
        return (0 ..< size).map { _ in
            // placekitten.com will return the same kitten picture if the same pixel height & width are requested,
            // so generate kittens with different width & height values.
            let deltaX = CGFloat(arc4random_uniform(10)) - 5
            let deltaY = CGFloat(arc4random_uniform(10)) - 5
            return CGSize(width: 350 + 2 * deltaX, height: 350 + 4 * deltaY)
        }
    }

    func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
        return kittenDataSource.count < kMaxLitterSize
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension KittensController: ASTableDataSource {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 1 + kittenDataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        // special-case the first row
        if blurbNodeIndexPath == indexPath {
            return BlurbNode()
        }

        let size = kittenDataSource[indexPath.row - 1]
        return KittenNode(size: size)
    }

    func tableNode(_ tableNode: ASTableNode, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return blurbNodeIndexPath != indexPath
    }

    func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // populate a new array of random-sized kittens
            let moarKittens = self.createLitter(with: kLitterBatchSize)

            // find number of kittens in the data source and create their indexPaths
            let existingRows = self.kittenDataSource.count + 1

            let indexPaths = (0 ..< moarKittens.count).map {
                IndexPath(row: existingRows + $0, section: 0)
            }

            // add new kittens to the data source & notify table of new indexpaths
            self.kittenDataSource.append(contentsOf: moarKittens)
            tableNode.insertRows(at: indexPaths, with: .fade)

            context.completeBatchFetching(true)
        }
    }
}

extension KittensController: ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)

        // Assume only kitten nodes are selectable (see -tableNode:shouldHighlightRowAtIndexPath:).
        guard let node = tableNode.nodeForRow(at: indexPath) as? KittenNode else {
            return
        }

        node.toggleImageEnlargement()
    }
}
