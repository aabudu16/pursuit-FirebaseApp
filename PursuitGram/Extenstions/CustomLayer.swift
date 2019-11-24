//
//  CustomLayer.swift
//  JustUsLeagueNYTimes
//
//  Created by Kevin Natera on 10/22/19.
//  Copyright © 2019 Jack Wong. All rights reserved.
//

import Foundation
import UIKit

struct CustomLayer{
   static let shared = CustomLayer()
   func createCustomlayer(layer:CALayer){
       layer.shadowColor = UIColor.black.cgColor
       layer.shadowOffset = CGSize(width: 0, height: 5.0)
       layer.shadowRadius = 5.0
       layer.shadowOpacity = 0.5
       layer.masksToBounds = false
   }
}
