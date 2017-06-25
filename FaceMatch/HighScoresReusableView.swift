//
//  HighScoresReusableView.swift
//  FaceMatch
//
//  Created by Kelvin Lau on 2017-06-25.
//  Copyright © 2017 Kelvin Lau. All rights reserved.
//

import UIKit

final class HighScoresReusableView: UICollectionReusableView {
  static let reuseIdentifier = "\(HighScoresReusableView.self)"
  @IBOutlet fileprivate var scoreLabel: UILabel!
  @IBOutlet fileprivate var accuracyLabel: UILabel!
  @IBOutlet fileprivate var nameTextField: UITextField!
  
  fileprivate var onSubmit: ((_ name: String, _ score: Int) -> ())!
  
  fileprivate var accuracy = 0 {
    didSet {
      accuracyLabel.text = "\(accuracy)%"
    }
  }
  
  fileprivate var score = 0 {
    didSet {
      scoreLabel.text = "\(score)"
    }
  }
  
  func configure(score: Int, accuracy: Int, onSubmit: @escaping (_ name: String, _ score: Int) -> ()) {
    self.onSubmit = onSubmit
    self.score = score
    self.accuracy = accuracy
  }
}

// MARK: - @IBActions
private extension HighScoresReusableView {
  @IBAction func submitTapped() {
    onSubmit(nameTextField.text!, score)
  }
}
