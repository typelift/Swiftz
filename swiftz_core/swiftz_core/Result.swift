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
  case Value(Box<V>)
  
  init(_ e: NSError?, _ v: V) {
    if let ex = e {
      self = Result.Error(ex)
    } else {
      self = Result.Value(Box(v))
    }
  }
  
  func toEither() -> Either<NSError, V> {
    switch self {
      case let Error(e): return .Left(Box(e))
      case let Value(v): return Either.Right(Box(v.value))
    }
  }
  
  func fold<B>(value: B, fn: V -> B) -> B {
    switch self {
      case Error(_): return value
      case let Value(v): return fn(v.value)
    }
  }
  
  static func error(e: NSError) -> Result<V> {
    return .Error(e)
  }
  
  static func value(v: V) -> Result<V> {
    return .Value(Box(v))
  }
}

// Equatable
func ==<V: Equatable>(lhs: Result<V>, rhs: Result<V>) -> Bool {
  switch (lhs, rhs) {
    case let (.Error(l), .Error(r)) where l == r: return true
    case let (.Value(l), .Value(r)) where l.value == r.value: return true
    default: return false
  }
}

func !=<V: Equatable>(lhs: Result<V>, rhs: Result<V>) -> Bool {
  return !(lhs == rhs)
}


// 'functions'
func pure<V>(a: V) -> Result<V> {
  return .Value(Box(a))
}

func <^><VA, VB>(f: VA -> VB, a: Result<VA>) -> Result<VB> {
  switch a {
  case let .Error(l): return .Error(l)
  case let .Value(r): return Result.Value(Box(f(r.value)))
  }
}

func <*><VA, VB>(f: Result<VA -> VB>, a: Result<VA>) -> Result<VB> {
  switch (a, f) {
  case let (.Error(l), _): return .Error(l)
  case let (.Value(r), .Error(m)): return .Error(m)
  case let (.Value(r), .Value(g)): return Result<VB>.Value(Box(g.value(r.value)))
  }
}

func >>=<VA, VB>(a: Result<VA>, f: VA -> Result<VB>) -> Result<VB> {
  switch a {
  case let .Error(l): return .Error(l)
  case let .Value(r): return f(r.value)
  }
}
