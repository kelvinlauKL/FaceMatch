//
//  Webservice+Highscores.swift
//  FaceMatch
//
//  Created by Kelvin Lau on 2017-06-25.
//  Copyright © 2017 Kelvin Lau. All rights reserved.
//

import Foundation

extension Webservice: HighscoresAPI {
  /*
   Expected response json:
   
   { 
     "scores": [
       { "name": "Kelvin Lau", "score": 30 },
       { "name": "Novjek", "score": 25 }
       // ...more
     ]
   }
  */
  func getHighscores(completion: @escaping ([Score]) -> ()) {
    
    // TODO: - add endpoint for highscores
    let url = URL(string: "")!
  
    URLSession.shared.dataTask(with: url) { data, _, _ in
      var scoresArray: [Score] = []
      defer {
        DispatchQueue.main.async {
          completion(scoresArray)
        }
      }
      
      let dict = self.response(from: data)
      guard let scoresDictionaries = dict["scores"] as? [[String: Any]] else { return }
      scoresArray = scoresDictionaries.map(Score.init)
    }.resume()
  }
  
  func postHighscore(name: String, score: Int, completion: @escaping (Result<Score>) -> ()) {
    let url = URL(string: "")!
    
    var request = URLRequest(url: url)
    request.httpMethod = HttpMethod.post.rawValue
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let params: [String: Any] = ["name": name, "score": score]
    request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
    
    URLSession.shared.dataTask(with: request) { data, _, _ in
      let dict = self.response(from: data)
      let score = Score(dict: dict)
      
      DispatchQueue.main.async {
        completion(.success(score))
      }
    }.resume()
  }
}
