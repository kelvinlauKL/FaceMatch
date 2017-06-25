//
//  HighScoresViewController.swift
//  FaceMatch
//
//  Created by Kelvin Lau on 2017-06-25.
//  Copyright © 2017 Kelvin Lau. All rights reserved.
//

import UIKit

final class HighScoresViewController: UIViewController {
  @IBOutlet fileprivate var collectionView: UICollectionView!
  
  fileprivate var highscores: [Score] = [] {
    didSet {
      collectionView.reloadData()
    }
  }
  fileprivate var webservice: HighscoresAPI!
  
  fileprivate var score = 0
  fileprivate var accuracy = 0
  
  fileprivate var onComplete: ((UIViewController) -> ())!
  class func instantiate(score: Int, accuracy: Int, webservice: HighscoresAPI, onComplete: @escaping (UIViewController) -> ()) -> HighScoresViewController {
    let storyboard = UIStoryboard(name: "\(HighScoresViewController.self)", bundle: nil)
    let highscoresVC = storyboard.instantiateInitialViewController() as! HighScoresViewController
    highscoresVC.webservice = webservice
    highscoresVC.score = score
    highscoresVC.accuracy = accuracy
    highscoresVC.onComplete = onComplete
    return highscoresVC
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    modalPresentationStyle = .custom
    transitioningDelegate = self
  }
}

// MARK: - Life Cycle
extension HighScoresViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    webservice.getHighscores { self.highscores = $0 }
  }
  
}

// MARK: - UICollectionViewDataSource
extension HighScoresViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScoreCell.reuseIdentifier, for: indexPath) as? ScoreCell else { fatalError() }
    cell.score = highscores[indexPath.row]
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return highscores.count
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HighScoresReusableView.reuseIdentifier, for: indexPath) as? HighScoresReusableView else { fatalError() }
    header.configure(score: score, accuracy: accuracy, onSubmit: { [weak self] name, score in
      self?.webservice.postHighscore(name: name, score: score) { [weak self] result in
        guard case .success(let score) = result else { fatalError("Wat") }
        self?.add(score: score)
      }
    })
    return header
  }
  
  // update the ui with the new score
  func add(score: Score) {
    
  }
}

// MARK: - UICollectionViewDelegate
extension HighScoresViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: 44)
  }
}

extension HighScoresViewController: UIViewControllerTransitioningDelegate {
  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    return DimmingPresentationController(presentedViewController: presented, presenting: presenting)
  }
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return BounceAnimationController()
  }
}

// MARK: - @IBActions
private extension HighScoresViewController {
  @IBAction func playAgainTapped() {
    onComplete(self)
  }
}
