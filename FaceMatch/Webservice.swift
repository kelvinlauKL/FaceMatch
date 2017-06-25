//
//  Webservice.swift
//  FaceMatch
//
//  Created by Kelvin Lau on 2017-06-24.
//  Copyright © 2017 Kelvin Lau. All rights reserved.
//

import Foundation
import SocketIO

enum Result<T> {
  case success(T)
  case failure(Error)
}

struct Webservice {
  enum EmotionMatchFailure: Error {
    case unknown
  }
  
  enum HttpMethod: String {
    case post = "POST"
    case get = "GET"
  }
  
  func response(from data: Data?) -> [String: Any] {
    guard let data = data else { fatalError("Server probably down.") }
    guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) else { fatalError("Wat") }
    guard let dict = jsonObject as? [String: Any] else { fatalError("Better check if the backend is returning key-value pairs.") }
    return dict
  }

}
