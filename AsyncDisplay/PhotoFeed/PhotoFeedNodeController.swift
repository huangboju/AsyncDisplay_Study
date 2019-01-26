//
//  PhotoFeedNodeController.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/27.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import AsyncDisplayKit

class PhotoFeedNodeController: PhotoFeedBaseController {
    
    var tableNode = ASTableNode()
    
    init() {
        super.init(node: tableNode)
        
        navigationItem.title = "ASDK"
        navigationController?.isNavigationBarHidden = true

        tableNode.dataSource = self
        tableNode.delegate = self
    }
    
    override func loadView() {
        super.loadView()
        tableNode.leadingScreensForBatching = 2.5
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override var tableView: UITableView? {
        return tableNode.view
    }
    
    override func loadPage() {
        loadPage(with: nil)
    }
    
    override func requestComments(for photos: [Any]) {
        
    }
    
    func loadPage(with context: ASBatchContext?) {
        photoFeed.requestPage(completionBlock: { (newPhotos) in
            self.insertNewRows(newPhotos!)
            self.requestComments(for: newPhotos!)
            guard let context = context else { return }
            context.completeBatchFetching(true)
        }, numResultsToReturn: 20)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotoFeedNodeController: ASTableDataSource {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return photoFeed.numberOfItemsInFeed()
    }

    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let photoModel = photoFeed.object(at: indexPath.row)
        // this will be executed on a background thread - important to make sure it's thread safe
        return {
            return PhotoCellNode(photo: photoModel)
        }
    }
}

extension PhotoFeedNodeController: ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
        context.beginBatchFetching()
        loadPage(with: context)
    }
}
