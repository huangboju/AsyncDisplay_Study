//
//  PhotoFeedBaseController.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/27.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import AsyncDisplayKit

protocol PhotoFeedControllerProtocol {
    func resetAllData()
}


class PhotoFeedBaseController: ASViewController<ASDisplayNode> {
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        return activityIndicatorView
    }()
    
    private(set) var photoFeed: PhotoFeedModel!

    var tableView: UITableView? {
        return nil
    }

    var imageSizeForScreenWidth: CGSize {
        let screenRect   = UIScreen.main.bounds
        let screenScale = UIScreen.main.scale
        return CGSize(width: screenRect.size.width * screenScale, height: screenRect.size.width * screenScale)
    }
    
    override func loadView() {
        super.loadView()
        
        photoFeed = PhotoFeedModel(photoFeedModelType: .popular, imageSize: imageSizeForScreenWidth)
        refreshFeed()
        
        let boundSize = view.bounds.size
        activityIndicatorView.sizeToFit()
        
        var refreshRect = activityIndicatorView.frame
        refreshRect.origin = CGPoint(x: (boundSize.width - activityIndicatorView.frame.width) / 2.0,
                                     y: (boundSize.height - activityIndicatorView.frame.height) / 2.0)
        activityIndicatorView.frame = refreshRect
        view.addSubview(activityIndicatorView)

        tableView?.allowsSelection = false
        tableView?.separatorStyle = .none

        view.backgroundColor = UIColor.white
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func refreshFeed() {
        activityIndicatorView.startAnimating()
        // small first batch
        
        photoFeed?.refreshFeed(completionBlock: { (newPhotos) in
            self.activityIndicatorView.stopAnimating()
            
            self.insertNewRows(newPhotos!)
            self.requestComments(for: newPhotos!)

            // immediately start second larger fetch
            self.loadPage()
        }, numResultsToReturn: 4)
    }

    func insertNewRows(_ newPhotos: [Any]) {
        let section = 0
        var indexPaths = [IndexPath]()

        let newTotalNumberOfPhotos = Int(photoFeed.numberOfItemsInFeed())
        for row in (newTotalNumberOfPhotos - newPhotos.count) ..< newTotalNumberOfPhotos {
            let path = IndexPath(row: row, section: section)
            indexPaths.append(path)
        }

        tableView?.insertRows(at: indexPaths, with: .none)
    }

    func requestComments(for photos: [Any]) {
        assert(false, "Subclasses must override this method")
    }

    func loadPage() {
        assert(false, "Subclasses must override this method")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PhotoFeedBaseController: PhotoFeedControllerProtocol {
    func resetAllData() {
        
    }
}
