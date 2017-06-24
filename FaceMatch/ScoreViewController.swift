//
//  ScoreViewController.swift
//  FaceMatch
//
//  Created by Kelvin Lau on 2017-06-24.
//  Copyright © 2017 Kelvin Lau. All rights reserved.
//

import UIKit

final class ScoreViewController: UIViewController {
  
  class func instantiate() -> ScoreViewController {
    let storyboard = UIStoryboard(name: "\(ScoreViewController.self)", bundle: nil)
    return storyboard.instantiateInitialViewController() as! ScoreViewController
  }
}
