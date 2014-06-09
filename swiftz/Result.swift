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
  
  init(_ e: NSError?, _ v: V) {
    if let ex = e {
      self = Result.Error(ex)
    } else {
      self = Result.Value({ v })
    }
  }
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


// 'functions'
func pure<V>(a: V) -> Result<V> {
  return .Value({ a })
}

func <^><VA, VB>(f: VA -> VB, a: Result<VA>) -> Result<VB> {
  switch a {
  case let .Error(l): return .Error(l)
  case let .Value(r): return Result.Value({ f(r()) })
  }
}

func <*><VA, VB>(f: Result<VA -> VB>, a: Result<VA>) -> Result<VB> {
  switch (a, f) {
  case let (.Error(l), _): return .Error(l)
  case let (.Value(r), .Error(m)): return .Error(m)
  case let (.Value(r), .Value(g)): return Result<VB>.Value({ g()(r()) })
  }
}

func >>=<VA, VB>(a: Result<VA>, f: VA -> Result<VB>) -> Result<VB> {
  switch a {
  case let .Error(l): return .Error(l)
  case let .Value(r): return f(r())
  }
}
