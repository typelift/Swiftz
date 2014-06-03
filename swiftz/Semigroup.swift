//
//  Semigroup.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

protocol Semigroup {
  typealias M
  func op(x: M, y: M) -> M
}

func sconcat<M, S: Semigroup where S.M == M>(s: S, h: M, t: Array<M>) -> M {
  return (t.reduce(h) { s.op($0, y: $1) })
}

class Min<A: Comparable>: Semigroup {
  typealias M = A
  
  func op(x: M, y: M) -> M {
    if x < y {
      return x
    } else {
      return y
    }
  }
}

class Max<A: Comparable>: Semigroup {
  typealias M = A
  
  func op(x: M, y: M) -> M {
    if x > y {
      return x
    } else {
      return y
    }
  }
}
