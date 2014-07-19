//
//  Either.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

enum Either<L, R> {
  case Left(Box<L>)
  case Right(Box<R>)
  
  func toResult(ev: L -> NSError) -> Result<R> {
    switch self {
      case let Left(e): return Result.Error(ev(e.value))
      case let Right(v): return .Value(Box(v.value))
    }
  }
  
  func fold<B>(value: B, fn: R -> B) -> B {
    switch self {
      case Left(_): return value
      case let Right(v): return fn(v.value)
    }
  }
  
  func flatMap<S>(fn: R -> Either<L, S>) -> Either<L, S> {
    return self >>= fn
  }
  
  static func left(l: L) -> Either<L, R> {
    return .Left(Box(l))
  }
  
  static func right(r: R) -> Either<L, R> {
    return .Right(Box(r))
  }
}

// Equatable
@infix func ==<L: Equatable, R: Equatable>(lhs: Either<L, R>, rhs: Either<L, R>) -> Bool {
  switch (lhs, rhs) {
    case let (.Left(l), .Left(r)) where l.value == r.value: return true
    case let (.Right(l), .Right(r)) where l.value == r.value: return true
    default: return false
  }
}

@infix func !=<L: Equatable, R: Equatable>(lhs: Either<L, R>, rhs: Either<L, R>) -> Bool {
  return !(lhs == rhs)
}

// 'functions'

func pure<L, R>(a: R) -> Either<L, R> {
  return .Right(Box(a))
}

@infix func <^><L, RA, RB>(f: RA -> RB, a: Either<L, RA>) -> Either<L, RB> {
  switch a {
    case let .Left(l): return .Left(l)
    case let .Right(r): return Either<L, RB>.Right(Box(f(r.value)))
  }
}

@infix func <*><L, RA, RB>(f: Either<L, RA -> RB>, a: Either<L, RA>) -> Either<L, RB> {
  switch a {
    case let .Left(l): return .Left(l)
    case let .Right(r): switch f {
    case let .Left(m): return .Left(m)
    case let .Right(g): return Either<L, RB>.Right(Box(g.value(r.value)))
      }
    }
}

@infix func >>=<L, RA, RB>(a: Either<L, RA>, f: RA -> Either<L, RB>) -> Either<L, RB> {
  switch a {
    case let .Left(l): return .Left(l)
    case let .Right(r): return f(r.value)
  }
}
