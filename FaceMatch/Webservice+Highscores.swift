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
    let url = URL(string: "http://192.168.25.109:8080/leaderboard")!
  
    URLSession.shared.dataTask(with: url) { data, _, _ in
      DispatchQueue.main.async {
        completion(self.scores(from: data))
      }
    }.resume()
  }
  
  func postHighscore(name: String, score: Int, completion: @escaping ([Score]) -> ()) {
    let url = URL(string: "http://192.168.25.109:8080/leaderboard")!
    
    var request = URLRequest(url: url)
    request.httpMethod = HttpMethod.post.rawValue
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let params: [String: Any] = ["name": name, "score": score]
    request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
    
    URLSession.shared.dataTask(with: request) { data, _, _ in
      DispatchQueue.main.async {
        completion(self.scores(from: data))
      }
    }.resume()
  }
  
  private func scores(from data: Data?) -> [Score] {
    guard let data = data else { return [] }
    guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) else { return [] }
    guard let dicts = jsonObject as? [[String: Any]] else { return [] }
    return dicts.map(Score.init)
  }
}
