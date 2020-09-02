//
//  OverviewComponentsViewController.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/21.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import AsyncDisplayKit

class OverviewComponentsViewController: ASDKViewController<ASDisplayNode> {

    var tableNode: ASTableNode

    override init() {
        tableNode = ASTableNode()
        super.init(node: tableNode)
        tableNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableNode.delegate =  self
        tableNode.dataSource = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let indexPathForSelectedRow = tableNode.indexPathForSelectedRow else {
            return
        }
        tableNode.deselectRow(at: indexPathForSelectedRow, animated: true)
    }

    func setupData() {
        var mutableLayoutSpecData: [OverviewDisplayNodeWithSizeBlock] = []

        // MARK: - ASInsetLayoutSpec

        var _parentNode: OverviewDisplayNodeWithSizeBlock!

        let insetchildNode = self.childNode()

        _parentNode = parentNode(with: insetchildNode)
        _parentNode.entryTitle = "ASInsetLayoutSpec"
        _parentNode.entryDescription = "Applies an inset margin around a component."
        _parentNode.sizeThatFitsBlock = { _ in
            return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 0), child: insetchildNode)
        }
        _parentNode.addSubnode(insetchildNode)

        mutableLayoutSpecData.append(_parentNode)


        // MARK: - ASBackgroundLayoutSpec
        let backgroundNode = ASDisplayNode()
        backgroundNode.backgroundColor = UIColor.green

        let backgroundChildNode = self.childNode()

        backgroundChildNode.backgroundColor = backgroundChildNode.backgroundColor?.withAlphaComponent(0.5)

        _parentNode = parentNode(with: backgroundChildNode)
        _parentNode.entryTitle = "ASBackgroundLayoutSpec"
        _parentNode.entryDescription = "Lays out a component, stretching another component behind it as a backdrop."
        _parentNode.sizeThatFitsBlock = { _ in
            return ASBackgroundLayoutSpec(child: backgroundChildNode, background: backgroundNode)
        }
        _parentNode.addSubnode(backgroundNode)
        _parentNode.addSubnode(backgroundChildNode)
        mutableLayoutSpecData.append(_parentNode)


        // MARK: - ASOverlayLayoutSpec
        let overlayNode = ASDisplayNode()
        overlayNode.backgroundColor = UIColor.green.withAlphaComponent(0.5)

        let overlayChildNode = self.childNode()

        _parentNode = parentNode(with: overlayChildNode)
        _parentNode.entryTitle = "ASOverlayLayoutSpec"
        _parentNode.entryDescription = "Lays out a component, stretching another component on top of it as an overlay."
        _parentNode.sizeThatFitsBlock = { _ in
            return ASOverlayLayoutSpec(child: overlayChildNode, overlay: overlayNode)
        }

        _parentNode.addSubnode(overlayChildNode)
        _parentNode.addSubnode(overlayNode)
        mutableLayoutSpecData.append(_parentNode)


        // MARK: - ASCenterLayoutSpec
        let centerChildNode = self.childNode()

        _parentNode = parentNode(with: centerChildNode)
        _parentNode.entryTitle = "ASCenterLayoutSpec"
        _parentNode.entryDescription = "Centers a component in the available space."
        _parentNode.sizeThatFitsBlock = { _ in
            return ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: [], child: centerChildNode)
        }
        _parentNode.addSubnode(centerChildNode)
        mutableLayoutSpecData.append(_parentNode)


        // MARK: - ASRatioLayoutSpec
        let ratioChildNode = self.childNode()

        _parentNode = parentNode(with: ratioChildNode)
        _parentNode.entryTitle = "ASRatioLayoutSpec"
        _parentNode.entryDescription = "Lays out a component at a fixed aspect ratio. Great for images, gifs and videos."
        _parentNode.sizeThatFitsBlock = { _ in
            return ASRatioLayoutSpec(ratio: 0.25, child: ratioChildNode)
        }
        _parentNode.addSubnode(ratioChildNode)
        mutableLayoutSpecData.append(_parentNode)


        // MARK: - ASRelativeLayoutSpec
        let relativeChildNode = self.childNode()

        _parentNode = parentNode(with: relativeChildNode)
        _parentNode.entryTitle = "ASRelativeLayoutSpec"
        _parentNode.entryDescription = "Lays out a component and positions it within the layout bounds according to vertical and horizontal positional specifiers. Similar to the “9-part” image areas, a child can be positioned at any of the 4 corners, or the middle of any of the 4 edges, as well as the center."
        _parentNode.sizeThatFitsBlock = { _ in
            return ASRelativeLayoutSpec(horizontalPosition: .end, verticalPosition: .center, sizingOption: [], child: relativeChildNode)
        }
        _parentNode.addSubnode(relativeChildNode)
        mutableLayoutSpecData.append(_parentNode)


        // MARK: - ASAbsoluteLayoutSpec
        let absoluteChildNode = self.childNode()
        // Add a layout position to the child node that the absolute layout spec will pick up and place it on that position
        absoluteChildNode.style.layoutPosition = CGPoint(x: 10.0, y: 10.0)

        _parentNode = parentNode(with: absoluteChildNode)
        _parentNode.entryTitle = "ASAbsoluteLayoutSpec"
        _parentNode.entryDescription = "Allows positioning children at fixed offsets."
        _parentNode.sizeThatFitsBlock = { _ in
            return ASAbsoluteLayoutSpec(children: [absoluteChildNode])
        }
        _parentNode.addSubnode(absoluteChildNode)
        mutableLayoutSpecData.append(_parentNode)


        // MARK: - Vertical ASStackLayoutSpec
        let vChildNode1 = self.childNode()
        vChildNode1.backgroundColor = UIColor.green

        let vChildNode2 = self.childNode()
        vChildNode2.backgroundColor = UIColor.blue

        let vChildNode3 = self.childNode()
        vChildNode3.backgroundColor = UIColor.yellow

        // If we just would add the childrent to the stack layout the layout would be to tall and run out of the edge of
        // the node as 50+50+50 = 150 but the parent node is only 100 height. To prevent that we set flexShrink on 2 of the
        // children to let the stack layout know it should shrink these children in case the layout will run over the edge
        vChildNode2.style.flexShrink = 1.0
        vChildNode3.style.flexShrink = 1.0

        let vChildNode = self.childNode()

        _parentNode = parentNode(with: vChildNode)
        _parentNode.entryTitle = "Vertical ASStackLayoutSpec"
        _parentNode.entryDescription = "Is based on a simplified version of CSS flexbox. It allows you to stack components vertically or horizontally and specify how they should be flexed and aligned to fit in the available space."

        _parentNode.sizeThatFitsBlock = { _ in
            let verticalStackLayoutSpec = ASStackLayoutSpec.vertical()
            verticalStackLayoutSpec.alignItems = .start
            verticalStackLayoutSpec.children = [vChildNode1, vChildNode2, vChildNode3]
            return verticalStackLayoutSpec
        }
        _parentNode.addSubnode(vChildNode1)
        _parentNode.addSubnode(vChildNode2)
        _parentNode.addSubnode(vChildNode3)
        mutableLayoutSpecData.append(_parentNode)


        // MARK: - Horizontal ASStackLayoutSpec
        let childNode1 = ASDisplayNode()
        childNode1.style.preferredSize = CGSize(width: 10.0, height: 20.0)
        childNode1.style.flexGrow = 1.0
        childNode1.backgroundColor = UIColor.green

        let childNode2 = ASDisplayNode()
        childNode2.style.preferredSize = CGSize(width: 10.0, height: 20.0)
        childNode2.style.alignSelf = .stretch
        childNode2.backgroundColor = UIColor.blue

        let childNode3 = ASDisplayNode()
        childNode3.style.preferredSize = CGSize(width: 10.0, height: 20.0)
        childNode3.backgroundColor = UIColor.yellow

        let childNode = self.childNode()
        _parentNode = parentNode(with: childNode)
        _parentNode.entryTitle = "Horizontal ASStackLayoutSpec"
        _parentNode.entryDescription = "Is based on a simplified version of CSS flexbox. It allows you to stack components vertically or horizontally and specify how they should be flexed and aligned to fit in the available space."
        _parentNode.sizeThatFitsBlock = { _ in

            // Create stack alyout spec to layout children
            let horizontalStackSpec = ASStackLayoutSpec.horizontal()
            horizontalStackSpec.alignItems = .start
            horizontalStackSpec.children = [childNode1, childNode2, childNode3]
            horizontalStackSpec.spacing = 5.0 // Spacing between children

            // Layout the stack layout with 100% width and 100% height of the parent node
            horizontalStackSpec.style.height = ASDimensionMakeWithFraction(1.0)
            horizontalStackSpec.style.width = ASDimensionMakeWithFraction(1.0)

            // Add a bit of inset
            return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 5.0), child: horizontalStackSpec)
        }
        _parentNode.addSubnode(childNode1)
        _parentNode.addSubnode(childNode2)
        _parentNode.addSubnode(childNode3)
        mutableLayoutSpecData.append(_parentNode)

        data.append(
            [
                "title": "Layout Specs",
                "data": mutableLayoutSpecData
            ]
        )
    }

    var data: [[String: Any]] = []
}

extension OverviewComponentsViewController: ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return data.count
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return (data[section]["data"] as? [OverviewDisplayNodeWithSizeBlock])?.count ?? 0
    }

    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        // You should get the node or data you want to pass to the cell node outside of the ASCellNodeBlock
        let node = (data[indexPath.section]["data"] as? [OverviewDisplayNodeWithSizeBlock])?[indexPath.row]
        return {
            let cellNode = OverviewTitleDescriptionCellNode()

            let titleNodeAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 14.0),
                .foregroundColor: UIColor.black
            ]

            cellNode.titleNode.attributedText = NSAttributedString(string: node!.entryTitle!, attributes: titleNodeAttributes)

            if let entryDescription = node?.entryDescription {
                let descriptionNodeAttributes = [
                    NSAttributedString.Key.foregroundColor: UIColor.lightGray
                ]
                cellNode.descriptionNode.attributedText = NSAttributedString(string: entryDescription, attributes: descriptionNodeAttributes)
            }

            return cellNode
        }
    }
}

extension OverviewComponentsViewController: ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        guard let node = data[indexPath.section]["data"] as? [OverviewDisplayNodeWithSizeBlock] else { return }

        let detail = OverviewDetailViewController(node: node[indexPath.row])
        navigationController?.pushViewController(detail, animated: true)
    }
}

// MARK: - Parent / Child Helper
extension OverviewComponentsViewController {
    func childNode() -> ASDisplayNode {
        let childNode = ASDisplayNode()
        childNode.style.preferredSize = CGSize(width: 50, height: 50)
        childNode.backgroundColor = UIColor.blue
        return childNode
    }

    func parentNode(with child: ASDisplayNode) -> OverviewDisplayNodeWithSizeBlock {
        let parentNode = OverviewDisplayNodeWithSizeBlock()
        parentNode.style.preferredSize = CGSize(width: 100, height: 100)
        parentNode.backgroundColor = UIColor.red
        return parentNode
    }
}
