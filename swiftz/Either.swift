//
//  Either.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

enum Either<L, R> {
  case Left(() -> L)
  case Right(() -> R)
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
