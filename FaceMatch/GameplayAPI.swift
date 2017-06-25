//
//  GameplayAPI.swift
//  FaceMatch
//
//  Created by Kelvin Lau on 2017-06-25.
//  Copyright © 2017 Kelvin Lau. All rights reserved.
//

import Foundation

protocol GameplayAPI {
  func send(imageData: Data, completion: @escaping (Result<(Emotion, Int)>) -> ())
}
