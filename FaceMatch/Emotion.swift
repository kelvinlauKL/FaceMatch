//
//  Emotion.swift
//  FaceMatch
//
//  Created by Kelvin Lau on 2017-06-24.
//  Copyright © 2017 Kelvin Lau. All rights reserved.
//

import UIKit

enum Emotion {
  case happy, sad
  
  var image: UIImage {
    switch self {
    case .happy:
      return #imageLiteral(resourceName: "happy")
    case .sad:
      return #imageLiteral(resourceName: "sad")
    }
  }
}
