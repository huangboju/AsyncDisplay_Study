//
//  ASAnimatedImage.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/19.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class ASAnimatedImage: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let imageNode = ASNetworkImageNode()

        imageNode.url = URL(string: "http://ww2.sinaimg.cn/or360/6fc6f04egw1evuciu6zqlj20hs0vkab3.jpg")
        imageNode.delegate = self
        imageNode.frame = view.bounds
        imageNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageNode.contentMode = .scaleAspectFit
        view.addSubnode(imageNode)

        navigationItem.showTitleView(text: "Loading")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ASAnimatedImage: ASNetworkImageNodeDelegate {
    func imageNode(_ imageNode: ASNetworkImageNode, didLoad image: UIImage) {
        navigationItem.hideTitleView()
    }
}
