//
//  Maybe.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

// Reasons for not using the built in option:
// - conversions to/from Either
// - In the future: our maybe can implement our functor

enum Maybe<A> {
  case Nothing
  case Just(A)

  // Functor
  func map<B>(f: A -> B, fc: Maybe<A>) -> Maybe<B> {
    switch fc {
      case .Nothing: return Maybe<B>.Nothing
      case let .Just(x): return Maybe<B>.Just(f(x))
    }
  }
}

// Equatable
func ==<A: Equatable>(lhs: Maybe<A>, rhs: Maybe<A>) -> Bool {
  switch lhs {
    case .Nothing: switch rhs {
      case .Nothing: return true
      case .Just(_): return false
    }
    case let .Just(l): switch rhs {
      case .Nothing: return false
      case let .Just(r): return l == r
    }
  }
}

func !=<A: Equatable>(lhs: Maybe<A>, rhs: Maybe<A>) -> Bool {
  return !(lhs == rhs)
}

// Comparable
func <=<A: Comparable>(lhs: Maybe<A>, rhs: Maybe<A>) -> Bool {
  switch lhs {
    case .Nothing: return true
    case let .Just(l): switch rhs {
      case .Nothing: return false
      case let .Just(r): return l <= r
    }
  }
}

func ><A: Comparable>(lhs: Maybe<A>, rhs: Maybe<A>) -> Bool {
  return !(lhs <= rhs)
}

func >=<A: Comparable>(lhs: Maybe<A>, rhs: Maybe<A>) -> Bool {
  return (lhs > rhs || lhs == rhs)
}

func <<A: Comparable>(lhs: Maybe<A>, rhs: Maybe<A>) -> Bool {
  return !(lhs >= rhs)
}
