//
//  HighscoresAPI.swift
//  FaceMatch
//
//  Created by Kelvin Lau on 2017-06-25.
//  Copyright © 2017 Kelvin Lau. All rights reserved.
//

protocol HighscoresAPI {
  func getHighscores(completion: @escaping ([Score]) -> ())
}
