//
//  ViewController.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/4/19.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//



class ViewController: UIViewController {
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    lazy var data: [[UIViewController.Type]] = [
        [
            ASAnimatedImage.self,
            ASCollectionViewController.self,
            ASDKLayoutTransition.self
        ],
        [
            PageController.self
        ],
        [
            OverviewComponentsViewController.self
        ],
        [
            CustomCollectionView.self
        ],
        [
            HorizontalScrollController.self
        ],
        [
            KittensController.self
        ],
        [
            LayoutOverViewController.self
        ],
        [
            PagerNodeController.self
        ],
        [
            SocialController.self,
            PhotoFeedNodeController.self,
            WBStatusTimelineViewController.self
        ],
        [
            StackLayoutController.self,
            FeedImageController.self
        ],
        [
            AnimationVC.self
        ]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "AsyncDisplayKit"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = "\(data[indexPath.section][indexPath.row].classForCoder())"
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: false)
        }
        let controller = data[indexPath.section][indexPath.row].init()
        controller.view.backgroundColor = UIColor.white
        navigationController?.pushViewController(controller, animated: true)
    }
}

