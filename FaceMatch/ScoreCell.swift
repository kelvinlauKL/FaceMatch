//
//  ScoreCell.swift
//  FaceMatch
//
//  Created by Kelvin Lau on 2017-06-25.
//  Copyright © 2017 Kelvin Lau. All rights reserved.
//

import UIKit

final class ScoreCell: UICollectionViewCell {
  static let reuseIdentifier = "\(ScoreCell.self)"
  @IBOutlet fileprivate var nameLabel: UILabel!
  @IBOutlet fileprivate var scoreLabel: UILabel!
  
  var score: Score? {
    didSet {
      guard let score = score else { return }
      nameLabel.text = score.name
      scoreLabel.text = "\(score.score)"
    }
  }
}
