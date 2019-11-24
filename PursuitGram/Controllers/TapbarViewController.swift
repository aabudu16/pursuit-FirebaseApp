//
//  TapbarViewController.swift
//  PursuitGram
//
//  Created by Mr Wonderful on 11/23/19.
//  Copyright © 2019 Mr Wonderful. All rights reserved.
//

import UIKit

class TapbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
       let feedViewController = FeedViewController()
        let imageUploadViewController = UINavigationController(rootViewController:  ImageUploadViewController())
        
        feedViewController.tabBarItem = UITabBarItem(title: "Feeds", image: UIImage(systemName: "folder"), tag: 0)
        imageUploadViewController.tabBarItem = UITabBarItem(title: "Upload Image", image: UIImage(systemName: "folder"), tag: 1)
        let viewControllerList = [ feedViewController, imageUploadViewController]
        viewControllers = viewControllerList
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
