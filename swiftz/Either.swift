//
//  Either.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

enum Either<A, B> {
  case Left(A)
  case Right(B)
}

// Equatable
func ==<A: Equatable, B: Equatable>(lhs: Either<A, B>, rhs: Either<A, B>) -> Bool {
  switch lhs {
    case let .Left(l): switch rhs {
      case let .Left(r): return l == r
      case .Right(_): return false
    }
    case let .Right(l): switch rhs {
      case let .Left(_): return false
      case let .Right(r): return l == r
    }
  }
}

func !=<A: Equatable, B: Equatable>(lhs: Either<A, B>, rhs: Either<A, B>) -> Bool {
  return !(lhs == rhs)
}
