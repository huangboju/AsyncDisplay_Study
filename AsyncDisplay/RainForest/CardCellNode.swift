
import UIKit
import AsyncDisplayKit

class CardCellNode: ASCellNode {
    let animalInfo: RainforestCardInfo

    fileprivate let backgroundImageNode: ASImageNode
    fileprivate let animalImageNode: ASNetworkImageNode

    fileprivate let animalNameTextNode: ASTextNode
    fileprivate let animalDescriptionTextNode: ASTextNode

    fileprivate let gradientNode: GradientNode //图片没显示出来时的渐变层

    init(animalInfo: RainforestCardInfo) {
        self.animalInfo = animalInfo

        backgroundImageNode = ASImageNode()
        animalImageNode     = ASNetworkImageNode()

        animalNameTextNode        = ASTextNode()
        animalDescriptionTextNode = ASTextNode()

        gradientNode = GradientNode()

        super.init()

        backgroundColor = UIColor.lightGray
        clipsToBounds = true

        //Animal Image
        animalImageNode.url = animalInfo.imageURL
        animalImageNode.clipsToBounds = true
        animalImageNode.delegate = self
        animalImageNode.placeholderFadeDuration = 0.15
        animalImageNode.contentMode = .scaleAspectFill
        //如果下载程序实现渐进式图像渲染，并且该值为true，图像的逐行渲染将作为图像下载显示。 无论此属性值如何，只有当节点可见时才会进行渲染。 默认为true。
        animalImageNode.shouldRenderProgressImages = true

        //Animal Name
        animalNameTextNode.attributedText = NSAttributedString(forTitleText: animalInfo.name)
        animalNameTextNode.placeholderEnabled = true
        animalNameTextNode.placeholderFadeDuration = 0.15
        animalNameTextNode.placeholderColor = UIColor(white: 0.777, alpha: 1.0)

        //Animal Description
        animalDescriptionTextNode.attributedText = NSAttributedString(forDescription: animalInfo.animalDescription)
        animalDescriptionTextNode.truncationAttributedText = NSAttributedString(forDescription: "…")
        animalDescriptionTextNode.backgroundColor = UIColor.clear
        animalDescriptionTextNode.placeholderEnabled = true
        animalDescriptionTextNode.placeholderFadeDuration = 0.15
        animalDescriptionTextNode.placeholderColor = UIColor(white: 0.777, alpha: 1.0)

        //Background Image
        backgroundImageNode.placeholderFadeDuration = 0.15
        backgroundImageNode.imageModificationBlock = { image in
            // 需要上面设置代理
            let newImage = UIImage.resize(image, newSize: CGSize(width: 100, height: 300)).applyBlur(withRadius: 10, tintColor: UIColor(white: 0.5, alpha: 0.3), saturationDeltaFactor: 1.8, maskImage: nil)
            return newImage ?? image
        }

        //Gradient Node
        gradientNode.isLayerBacked = true
        gradientNode.isOpaque = false

        addSubnode(backgroundImageNode)
        addSubnode(animalImageNode)
        addSubnode(gradientNode)

        addSubnode(animalNameTextNode)
        addSubnode(animalDescriptionTextNode)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let ratio = constrainedSize.min.height / constrainedSize.max.width

        let imageRatioSpec = ASRatioLayoutSpec(ratio: ratio, child: animalImageNode)

        let gradientOverlaySpec = ASOverlayLayoutSpec(child: imageRatioSpec, overlay: gradientNode)

        let relativeSpec = ASRelativeLayoutSpec(horizontalPosition: .start, verticalPosition: .end, sizingOption: [], child: animalNameTextNode)

        let nameInsetSpec = ASInsetLayoutSpec(insets: UIEdgeInsets.init(top: 0, left: 16, bottom: 8, right: 0), child: relativeSpec)

        let nameOverlaySpec = ASOverlayLayoutSpec(child: gradientOverlaySpec, overlay: nameInsetSpec)

        let descriptionTextInsetSpec = ASInsetLayoutSpec(insets: UIEdgeInsets.init(top: 16.0, left: 28.0, bottom: 12.0, right: 28.0), child: animalDescriptionTextNode)

        let verticalStackSpec = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .start, children: [nameOverlaySpec, descriptionTextInsetSpec])

        let backgroundLayoutSpec = ASBackgroundLayoutSpec(child: verticalStackSpec, background: backgroundImageNode)

        return backgroundLayoutSpec
    }
}

// MARK: - ASNetworkImageNodeDelegate

extension CardCellNode: ASNetworkImageNodeDelegate {
    func imageNode(_ imageNode: ASNetworkImageNode, didLoad image: UIImage) {
        backgroundImageNode.image = image
    }
}
