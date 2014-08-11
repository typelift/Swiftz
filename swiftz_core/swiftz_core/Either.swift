//
//  Either.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

public enum Either<L, R> {
  case Left(Box<L>)
  case Right(Box<R>)

  public func toResult(ev: L -> NSError) -> Result<R> {
    switch self {
    case let Left(e): return Result.Error(ev(e.value))
    case let Right(v): return .Value(Box(v.value))
    }
  }

  public func fold<B>(value: B, f: R -> B) -> B {
    switch self {
    case Left(_): return value
    case let Right(v): return f(v.value)
    }
  }

  public func flatMap<S>(f: R -> Either<L, S>) -> Either<L, S> {
    return self >>= f
  }

  public static func left(l: L) -> Either<L, R> {
    return .Left(Box(l))
  }

  public static func right(r: R) -> Either<L, R> {
    return .Right(Box(r))
  }

  public func either<A>(onL: L -> A, onR: R -> A) -> A {
    switch self {
    case let Left(e): return onL(e.value)
    case let Right(e): return onR(e.value)
    }
  }
}

// Equatable
public func ==<L: Equatable, R: Equatable>(lhs: Either<L, R>, rhs: Either<L, R>) -> Bool {
  switch (lhs, rhs) {
  case let (.Left(l), .Left(r)) where l.value == r.value: return true
  case let (.Right(l), .Right(r)) where l.value == r.value: return true
  default: return false
  }
}

public func !=<L: Equatable, R: Equatable>(lhs: Either<L, R>, rhs: Either<L, R>) -> Bool {
  return !(lhs == rhs)
}

// 'functions'

public func pure<L, R>(a: R) -> Either<L, R> {
  return .Right(Box(a))
}

public func <^><L, RA, RB>(f: RA -> RB, a: Either<L, RA>) -> Either<L, RB> {
  switch a {
  case let .Left(l): return .Left(l)
  case let .Right(r): return Either<L, RB>.Right(Box(f(r.value)))
  }
}

public func <*><L, RA, RB>(f: Either<L, RA -> RB>, a: Either<L, RA>) -> Either<L, RB> {
  switch a {
  case let .Left(l): return .Left(l)
  case let .Right(r): switch f {
  case let .Left(m): return .Left(m)
  case let .Right(g): return Either<L, RB>.Right(Box(g.value(r.value)))
    }
  }
}

public func >>=<L, RA, RB>(a: Either<L, RA>, f: RA -> Either<L, RB>) -> Either<L, RB> {
  switch a {
  case let .Left(l): return .Left(l)
  case let .Right(r): return f(r.value)
  }
}
