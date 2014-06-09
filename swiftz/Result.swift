//
//  Result.swift
//  swiftz
//
//  Created by Maxwell Swadling on 9/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

// Result is similar to an Either, except the Left side is always an NSError.

import Foundation

enum Result<V> {
  case Error(NSError)
  case Value(() -> V)
}

// Equatable
func ==<V: Equatable>(lhs: Result<V>, rhs: Result<V>) -> Bool {
  switch (lhs, rhs) {
    case let (.Error(l), .Error(r)) where l == r: return true
    case let (.Value(l), .Value(r)) where l() == r(): return true
    default: return false
  }
}

func !=<V: Equatable>(lhs: Result<V>, rhs: Result<V>) -> Bool {
  return !(lhs == rhs)
}
