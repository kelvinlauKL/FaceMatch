//
//  Webservice.swift
//  FaceMatch
//
//  Created by Kelvin Lau on 2017-06-24.
//  Copyright © 2017 Kelvin Lau. All rights reserved.
//

import Foundation
import SocketIO

extension NSMutableData {
  func appendString(_ string: String) {
    let data = string.data(using: .utf8, allowLossyConversion: false)
    append(data!)
  }
}

enum Webservice {
  enum EmotionMatchFailure: Error {
    case unknown
  }
  
  enum Result<T> {
    case success(T)
    case failure(Error)
  }
  
  enum HttpMethod: String {
    case post = "POST"
    case get = "GET"
  }
  
  static let baseURL = URL(string: "https://192.168.25.109:8080")!
  static let baseSocketURL = URL(string: "http://192.168.25.151:3000")!
  
  static func send(imageData: Data, emotion: Emotion?, completion: @escaping (Result<(Emotion, Int)>) -> ()) {
    let url = URL(string: "http://192.168.25.109:8080/emotion")!
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = HttpMethod.post.rawValue
    
    let boundary = "Boundary-\(UUID().uuidString)"
    urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    var params: [String: Any] = [:]
    if let emotion = emotion {
      params["emotion"] = emotion.rawValue
    }
    urlRequest.httpBody = createBody(parameters: params, boundary: boundary, data: imageData, mimeType: "image/jpg", filename: "camera")
    
    URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
      guard let data = data else { fatalError() }
      guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) else { fatalError() }
      guard let dict = jsonObject as? [String: Any] else { fatalError() }
      print(dict)
      
      DispatchQueue.main.async {
        if let emoValue = dict["emotion"] as? String, let emotion = Emotion(rawValue: emoValue), let score = dict["score"] as? Int {
          return completion(.success((emotion, score)))
        } else {
          return completion(.failure(EmotionMatchFailure.unknown))
        }
      }
    }.resume()
  }
  
  private static func createBody(parameters: [String: Any],
                  boundary: String,
                  data: Data,
                  mimeType: String,
                  filename: String) -> Data {
    let body = NSMutableData()
    
    let boundaryPrefix = "--\(boundary)\r\n"
    
    for (key, value) in parameters {
      body.appendString(boundaryPrefix)
      body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
      body.appendString("\(value)\r\n")
    }
    
    body.appendString(boundaryPrefix)
    body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
    body.appendString("Content-Type: \(mimeType)\r\n\r\n")
    body.append(data)
    body.appendString("\r\n")
    body.appendString("--".appending(boundary.appending("--")))
    
    return body as Data
  }

}
