//
//  SocialController.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/26.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import AsyncDisplayKit

class SocialController: ASViewController<ASTableNode> {
    
    var tableNode: ASTableNode!
    
    var data: [Post] = []
    
    init() {
        tableNode = ASTableNode(style: .plain)
        tableNode.inverted = true
        super.init(node: tableNode)

        tableNode.delegate = self
        tableNode.dataSource = self
        tableNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        title = "Timeline"

        createSocialAppDataSource()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableNode.view.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let inset: CGFloat = 64
        tableNode.view.contentInset = UIEdgeInsetsMake(-inset, 0, inset, 0)
        tableNode.view.scrollIndicatorInsets = UIEdgeInsetsMake(-inset, 0, inset, 0)
    }

    func createSocialAppDataSource() {
        
        let post1 = Post(
            username: "@appleguy",
            name: "Apple Guy",
            photo: "https://avatars1.githubusercontent.com/u/565251?v=3&s=96",
            post: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
            time: "3s",
            media: "",
            via: 0,
            likes: Int(arc4random_uniform(74)),
            comments: Int(arc4random_uniform(40))
        )
        
        
        
        let post2 = Post(
            username: "@nguyenhuy",
            name: "Huy Nguyen",
            photo: "https://avatars2.githubusercontent.com/u/587874?v=3&s=96",
            post: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
            time: "1m",
            media: "",
            via: 1,
            likes: Int(arc4random_uniform(74)),
            comments: Int(arc4random_uniform(40))
        )

        
        
        let post3 = Post(
            username: "@veryyyylongusername",
            name: "Alex Long Name",
            photo: "https://avatars1.githubusercontent.com/u/8086633?v=3&s=96",
            post: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
            time: "3:02",
            media: "http://www.ngmag.ru/upload/iblock/f93/f9390efc34151456598077c1ba44a94d.jpg",
            via: 2,
            likes: Int(arc4random_uniform(74)),
            comments: Int(arc4random_uniform(40))
        )

        
        let post4 = Post(
            username: "@vitalybaev",
            name: "Vitaly Baev",
            photo: "https://avatars0.githubusercontent.com/u/724423?v=3&s=96",
            post: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. https://github.com/facebook/AsyncDisplayKit Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
            time: "yesterday",
            media: "",
            via: 1,
            likes: Int(arc4random_uniform(74)),
            comments: Int(arc4random_uniform(40))
        )
        
        let posts = [post1, post2, post3, post4]
        
        for _ in 0 ..< 100 {
            let j = Int(arc4random_uniform(74)) % 4
            data.append(posts[j])
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SocialController: ASTableDataSource {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let post = data[indexPath.row]
        return {
            return PostNode(post: post)
        }
    }
}

extension SocialController: ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
}
