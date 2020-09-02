//
//  LayoutOverViewController.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/25.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import AsyncDisplayKit

class LayoutOverViewController: ASDKViewController<ASDisplayNode> {
    
    var tableNode: ASTableNode!
    
    fileprivate lazy var layoutExamples: [LayoutExampleNode.Type] = []
    
    override init() {
        tableNode = ASTableNode()

        super.init(node: tableNode)
        
        title = "Layout Examples"
        
        tableNode.delegate = self
        tableNode.dataSource = self
        
        layoutExamples = [
            HeaderWithRightAndLeftItems.self,
            PhotoWithInsetTextOverlay.self,
            PhotoWithOutsetIconOverlay.self,
            FlexibleSeparatorSurroundingContent.self
        ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let indexPath = tableNode.indexPathForSelectedRow else { return }
        tableNode.deselectRow(at: indexPath, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LayoutOverViewController: ASTableDataSource {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return layoutExamples.count
    }

    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        return OverviewCellNode(cls: layoutExamples[indexPath.row])
    }
}

extension LayoutOverViewController: ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {

        let layoutExampleClass = layoutExamples[indexPath.row]
        let detail = LayoutExampleViewController(layoutExample: layoutExampleClass.init())
        navigationController?.pushViewController(detail, animated: true)
    }
}
