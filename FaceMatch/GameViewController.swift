//
//  GameViewController.swift
//  FaceMatch
//
//  Created by Kelvin Lau on 2017-06-24.
//  Copyright © 2017 Kelvin Lau. All rights reserved.
//

import UIKit

final class GameViewController: UIViewController {
  
  class func instantiate() -> GameViewController {
    let storyboard = UIStoryboard(name: "\(GameViewController.self)", bundle: nil)
    return storyboard.instantiateInitialViewController() as! GameViewController
  }
}
