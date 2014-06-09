//
//  Either.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

enum Either<L, R> {
  case Left(@auto_closure () -> L)
  case Right(@auto_closure () -> R)
}

// Equatable
func ==<L: Equatable, R: Equatable>(lhs: Either<L, R>, rhs: Either<L, R>) -> Bool {
  switch (lhs, rhs) {
    case let (.Left(l), .Left(r)) where l() == r(): return true
    case let (.Right(l), .Right(r)) where l() == r(): return true
    default: return false
  }
}

func !=<L: Equatable, R: Equatable>(lhs: Either<L, R>, rhs: Either<L, R>) -> Bool {
  return !(lhs == rhs)
}

// 'functions'

func pure<L, R>(a: R) -> Either<L, R> {
  return .Right(a)
}

func <^><L, RA, RB>(f: RA -> RB, a: Either<L, RA>) -> Either<L, RB> {
  switch a {
  case let .Left(l): return .Left(l)
  case let .Right(r): return Either<L, RB>.Right(f(r()))
  }
}

func <*><L, RA, RB>(f: Either<L, RA -> RB>, a: Either<L, RA>) -> Either<L, RB> {
  switch a {
  case let .Left(l): return .Left(l)
  case let .Right(r): switch f {
  case let .Left(m): return .Left(m)
  case let .Right(g): return Either<L, RB>.Right(g()(r()))
    }
  }
}

func >>=<L, RA, RB>(a: Either<L, RA>, f: RA -> Either<L, RB>) -> Either<L, RB> {
  switch a {
  case let .Left(l): return .Left(l)
  case let .Right(r): return f(r())
  }
}
