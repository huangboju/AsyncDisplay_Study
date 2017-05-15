//
//  PhotoCellNode.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/27.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

let FLAT_LAYOUT = 0

let DEBUG_PHOTOCELL_LAYOUT          = 0

let HEADER_HEIGHT                   = 50
let USER_IMAGE_HEIGHT               = 30
let HORIZONTAL_BUFFER: CGFloat      = 10
let VERTICAL_BUFFER: CGFloat        = 5
let FONT_SIZE: CGFloat              = 14

let InsetForAvatar = UIEdgeInsetsMake(HORIZONTAL_BUFFER, 0, HORIZONTAL_BUFFER, HORIZONTAL_BUFFER)
let InsetForHeader = UIEdgeInsetsMake(0, HORIZONTAL_BUFFER, 0, HORIZONTAL_BUFFER)
let InsetForFooter = UIEdgeInsetsMake(VERTICAL_BUFFER, HORIZONTAL_BUFFER, VERTICAL_BUFFER, HORIZONTAL_BUFFER)

class PhotoCellNode: ASCellNode {
    var photoModel: PhotoModel!
    var photoCommentsNode: PhotoCommentsNode!
    let userAvatarImageNode = ASNetworkImageNode()
    let photoImageNode = ASNetworkImageNode()
    let userNameLabel = ASTextNode()
    let photoLocationLabel = ASTextNode()
    var photoTimeIntervalSincePostLabel: ASTextNode!
    var photoLikesLabel: ASTextNode!
    var photoDescriptionLabel: ASTextNode!
    
    
    init(photo: PhotoModel?) {
        super.init()
        
        guard let photo = photo else {
            return
        }

        photoModel = photo

        userAvatarImageNode.url = photo.ownerUserProfile.userPicURL   // FIXME: make round
        
        // FIXME: autocomplete for this line seems broken
        userAvatarImageNode.imageModificationBlock = { image in
            let profileImageSize = CGSize(width: USER_IMAGE_HEIGHT, height: USER_IMAGE_HEIGHT)
            return image.makeCircularImage(with: profileImageSize)
        }
        
        photoImageNode.url      = photo.url
        photoImageNode.isLayerBacked = true
        
        userNameLabel.attributedText = photo.ownerUserProfile.usernameAttributedString(withFontSize: FONT_SIZE)
        
        
        photoLocationLabel.maximumNumberOfLines = 1
        photo.location?.reverseGeocodedLocation { [unowned self] (locationModel) in
            // check and make sure this is still relevant for this cell (and not an old cell)
            // make sure to use _photoModel instance variable as photo may change when cell is reused,
            // where as local variable will never change
            if locationModel == photo.location {
                self.photoLocationLabel.attributedText = photo.locationAttributedString(withFontSize: FONT_SIZE)
                self.setNeedsLayout()
            }
        }
        
        
        photoTimeIntervalSincePostLabel = createLayerBackedTextNode(with: photo.uploadDateAttributedString(withFontSize: FONT_SIZE))
        photoLikesLabel                 = createLayerBackedTextNode(with: photo.likesAttributedString(withFontSize: FONT_SIZE))
        photoDescriptionLabel           = createLayerBackedTextNode(with: photo.descriptionAttributedString(withFontSize: FONT_SIZE))
        photoDescriptionLabel.maximumNumberOfLines = 3
        
        photoCommentsNode = PhotoCommentsNode()
        
        photoCommentsNode.isLayerBacked = true
        
        // instead of adding everything addSubnode:
        automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        // The style below is the more structured, visual, and declarative style.  It is functionally identical.
        
        
        let userNameNode = userNameLabel.styled { $0.flexShrink = 1.0 }
        let photoLocationNode = photoLocationLabel.styled { $0.flexShrink = 1.0 }
        let items: [ASDisplayNode] = photoLocationLabel.attributedText != nil ? [userNameNode, photoLocationNode] : [userNameNode]


        let avatarNode = ASInsetLayoutSpec(insets: InsetForAvatar, child: userAvatarImageNode.styled { $0.preferredSize = CGSize(width: USER_IMAGE_HEIGHT, height: USER_IMAGE_HEIGHT) })

        let item2 = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .stretch, children: items).styled { $0.flexShrink = 1}

        let placeholder = ASLayoutSpec().styled { $0.flexGrow = 1}
        let photoTimeNode = photoTimeIntervalSincePostLabel.styled { $0.spacingBefore = HORIZONTAL_BUFFER }

        let stackItem = ASStackLayoutSpec(direction: .horizontal, spacing: 0, justifyContent: .start, alignItems: .center, children: [avatarNode, item2, placeholder, photoTimeNode])

        let headInset = ASInsetLayoutSpec(insets: InsetForHeader, child: stackItem)
        
    
        // Center photo with ratio
        let photoRatio = ASRatioLayoutSpec(ratio: 1, child: photoImageNode)

        // Footer stack with inset
        let footer = ASInsetLayoutSpec(insets: InsetForFooter, child: ASStackLayoutSpec(direction: .vertical, spacing: VERTICAL_BUFFER, justifyContent: .start, alignItems: .stretch, children: [
            photoLikesLabel,
            photoDescriptionLabel,
            photoCommentsNode
            ]))

        
        return ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .stretch, children: [headInset, photoRatio, footer])
    }
    
    override func didEnterPreloadState() {
        super.didEnterPreloadState()
        photoModel.commentFeed.refreshFeed { (newComments) in
            self.loadComments(for: self.photoModel)
        }
    }

    func createLayerBackedTextNode(with attributedString: NSAttributedString) -> ASTextNode {
        let textNode              = ASTextNode()
        textNode.isLayerBacked      = true
        textNode.attributedText   = attributedString
        return textNode
    }

    func loadComments(for photo: PhotoModel) {
        if photo.commentFeed.numberOfItemsInFeed() > 0 {
            photoCommentsNode.updateWithCommentFeedModel(photo.commentFeed)
            setNeedsLayout()
        }
    }
}
