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
  switch lhs {
    case let .Left(l): switch rhs {
      case let .Left(r): return l() == r()
      case .Right(_): return false
    }
    case let .Right(l): switch rhs {
      case let .Left(_): return false
      case let .Right(r): return l() == r()
    }
  }
}

func !=<L: Equatable, R: Equatable>(lhs: Either<L, R>, rhs: Either<L, R>) -> Bool {
  return !(lhs == rhs)
}
