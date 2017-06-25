//
//  HighScoresViewController.swift
//  FaceMatch
//
//  Created by Kelvin Lau on 2017-06-25.
//  Copyright © 2017 Kelvin Lau. All rights reserved.
//

import UIKit

final class HighScoresViewController: UIViewController {
  @IBOutlet fileprivate var tableView: UITableView!
  
  fileprivate var highscores: [Score] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  fileprivate var webservice: HighscoresAPI!
  
  class func instantiate(webservice: HighscoresAPI) -> HighScoresViewController {
    let storyboard = UIStoryboard(name: "\(HighScoresViewController.self)", bundle: nil)
    let highscoresVC = storyboard.instantiateInitialViewController() as! HighScoresViewController
    highscoresVC.webservice = webservice
    return highscoresVC
  }
}

// MARK: - Life Cycle
extension HighScoresViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    webservice.getHighscores { self.highscores = $0 }
  }
}
// MARK: - UITableViewDataSource
extension HighScoresViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }
}
