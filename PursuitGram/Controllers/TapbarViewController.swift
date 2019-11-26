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
       setupTabBarController()
    }
    
    private func setupTabBarController(){
        view.backgroundColor = .white
              let feedViewController =  UINavigationController(rootViewController:  FeedViewController())
               let imageUploadViewController = UINavigationController(rootViewController:  ImageUploadViewController())
               
               feedViewController.tabBarItem = UITabBarItem(title: "Feeds", image: UIImage(systemName: "folder"), tag: 0)
               imageUploadViewController.tabBarItem = UITabBarItem(title: "Upload Image", image: UIImage(systemName: "folder"), tag: 1)
               let viewControllerList = [ feedViewController, imageUploadViewController]
               viewControllers = viewControllerList
    }
}
