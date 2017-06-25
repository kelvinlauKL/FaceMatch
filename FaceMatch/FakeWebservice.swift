//
//  FakeWebservice.swift
//  FaceMatch
//
//  Created by Kelvin Lau on 2017-06-25.
//  Copyright © 2017 Kelvin Lau. All rights reserved.
//

import Foundation

struct FakeWebservice {
}

extension FakeWebservice: HighscoresAPI {
  func getHighscores(completion: @escaping ([Score]) -> ()) {
    let scores = [
      Score(name: "Novjek", score: 45),
      Score(name: "Slav", score: 42),
      Score(name: "Baljeet", score: 40),
      Score(name: "Kelvin Lau", score: 35),
      Score(name: "Denis", score: 30),
      Score(name: "Arthur", score: 25),
      Score(name: "Kinnan", score: 20),
      Score(name: "Godot", score: 10),
      Score(name: "Marrie", score: 5),
      Score(name: "Ali", score: 2),
      ]
    completion(scores)
  }
  
  func postHighscore(name: String, score: Int, completion: @escaping (Result<Score>) -> ()) {
    completion(.success(Score(name: name, score: score)))
  }
}

extension FakeWebservice: GameplayAPI {
  func send(imageData: Data, completion: @escaping (Result<(Emotion, Int)>) -> ()) {
    completion(.success((Emotion.sad), 2))
  }
}
