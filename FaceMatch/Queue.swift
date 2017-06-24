//
//  Queue.swift
//  FaceMatch
//
//  Created by Kelvin Lau on 2017-06-24.
//  Copyright © 2017 Kelvin Lau. All rights reserved.
//

struct Queue<T> {
  private var array: [T] = []
  
  mutating func enqueue(_ value: T) {
    array.append(value)
  }
  
  mutating func dequeue() -> T? {
    return array.removeFirst()
  }
}
