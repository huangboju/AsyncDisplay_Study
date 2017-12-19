//
//  PhotoCommentsNode.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/27.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

let INTER_COMMENT_SPACING: CGFloat = 5
let NUM_COMMENTS_TO_SHOW  = 3

import AsyncDisplayKit

class PhotoCommentsNode: ASDisplayNode {
    var commentFeed: CommentFeedModel?
    
    lazy var commentNodes: [ASTextNode] = []
    
    override init() {
        super.init()
        
        automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASStackLayoutSpec(direction: .vertical, spacing: INTER_COMMENT_SPACING, justifyContent: .start, alignItems: .stretch, children: commentNodes)
    }
    
    func updateWithCommentFeedModel(_ feed: CommentFeedModel) {
        commentFeed = feed
        commentNodes.removeAll(keepingCapacity: true)
        if let commentFeed = commentFeed {
            createCommentLabels()

            let addViewAllCommentsLabel = feed.numberOfComments(forPhotoExceedsInteger: NUM_COMMENTS_TO_SHOW)
            var commentLabelString: NSAttributedString
            var labelsIndex = 0

            if addViewAllCommentsLabel {
                commentLabelString = commentFeed.viewAllCommentsAttributedString()
                commentNodes[labelsIndex].attributedText = commentLabelString
                labelsIndex += 1
            }

            let numCommentsInFeed = commentFeed.numberOfItemsInFeed()

            for feedIndex in 0 ..< numCommentsInFeed {
                commentLabelString = commentFeed.object(at: feedIndex).commentAttributedString()
                commentNodes[labelsIndex].attributedText = commentLabelString
                labelsIndex += 1
            }
            
            setNeedsLayout()
        }
    }
    
    private func createCommentLabels() {

        guard let commentFeed = commentFeed else { return }

        let addViewAllCommentsLabel = commentFeed.numberOfComments(forPhotoExceedsInteger: NUM_COMMENTS_TO_SHOW)
        let numCommentsInFeed = commentFeed.numberOfItemsInFeed()
        
        let numLabelsToAdd = (addViewAllCommentsLabel) ? numCommentsInFeed + 1 : numCommentsInFeed
        
        for _ in 0 ..< numLabelsToAdd {
            let commentLabel = ASTextNode()
            commentLabel.isLayerBacked = true
            commentLabel.maximumNumberOfLines = 3
            commentNodes.append(commentLabel)
        }
    }
}
