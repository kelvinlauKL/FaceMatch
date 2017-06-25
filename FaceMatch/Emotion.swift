//
//  Emotion.swift
//  FaceMatch
//
//  Created by Kelvin Lau on 2017-06-24.
//  Copyright © 2017 Kelvin Lau. All rights reserved.
//

import UIKit

enum Emotion: String {
  case happy, sad, angry, fear, neutral, surprise
  
  var image: UIImage {
    switch self {
    case .happy:
      return #imageLiteral(resourceName: "happyface")
    case .sad:
      return #imageLiteral(resourceName: "sadface")
    default:
      fatalError()
    }
  }
    
  static var allValues: [Emotion] {
    return [.happy, .sad]
  }
  
  static var random: Emotion {
    let randomNumber = Int(arc4random_uniform(100))
    return allValues[randomNumber % allValues.count]
  }
}
