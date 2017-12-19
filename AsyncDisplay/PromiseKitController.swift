//
//  PromiseKitController.swift
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/5/18.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

//import PromiseKit

class PromiseKitController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        fetchData()
        
    }

//    func fetchData() {
//        Promise<Data> { (fulfill, reject) in
//            URLSession.shared
//                .dataTask(with: URL(string: "https://httpbin.org/get?foo=bar")!) { (data, _, error) in
//                    if let data = data {
//                        fulfill(data)
//                    } else if let error = error {
//                        reject(error)
//                    }
//                }
//                .resume()
//            }
//            .then { (data) in
//                Promise<Any> { (fulfill, error) in
//                    do {
//                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
//                        fulfill(json)
//                    } catch {
//                        fulfill(error)
//                    }
//                }
//            }
//            .then { (json) in
//                print(json)
//            }.catch { (error) in
//                print(error)
//            }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
