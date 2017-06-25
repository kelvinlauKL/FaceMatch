//
//  RoundableView.swift
//  FaceMatch
//
//  Created by Kelvin Lau on 2017-06-25.
//  Copyright © 2017 Kelvin Lau. All rights reserved.
//

import UIKit

@IBDesignable
class RoundableView: UIView {
  @IBInspectable var cornerRadius: CGFloat = 0 {
    didSet {
      layer.cornerRadius = cornerRadius
      layer.masksToBounds = cornerRadius > 0
    }
  }
  
  @IBInspectable var borderWidth: CGFloat = 0 {
    didSet {
      layer.borderWidth = borderWidth
    }
  }
  
  @IBInspectable var borderColor: UIColor? {
    didSet {
      layer.borderColor = borderColor?.cgColor
    }
  }
}
