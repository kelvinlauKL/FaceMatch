//
//  Score.swift
//  FaceMatch
//
//  Created by Kelvin Lau on 2017-06-25.
//  Copyright © 2017 Kelvin Lau. All rights reserved.
//

struct Score {
  let name: String
  let score: Int
  
  init(name: String, score: Int) {
    self.name = name
    self.score = score
  }
  
  init(dict: [String: Any]) {
    name = dict["name"] as! String
    score = dict["score"] as! Int
  }
}
