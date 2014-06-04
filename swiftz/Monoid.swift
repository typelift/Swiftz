//
//  Monoid.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

protocol Monoid: Semigroup {
  func mzero() -> M
}

func mconcat<M, S: Monoid where S.M == M>(s: S, t: Array<M>) -> M {
  return (t.reduce(s.mzero()) { s.op($0, y: $1) })
}

class Sum<A, N: Num where N.N == A>: Monoid {
  typealias M = A
  let n: () -> N // work around for rdar://17109323
  
  // explicit instance passing
  init(i: () -> N) {
    n = i
  }
  
  func mzero() -> M { return n().zero() }
  func op(x: M, y: M) -> M {
    return n().add(x, y: y);
  }
}

class Product<A, N: Num where N.N == A>: Monoid {
  typealias M = A
  let n: () -> N
  init(i: () -> N) {
    n = i
  }
  func mzero() -> M { return n().succ(n().zero()) }
  func op(x: M, y: M) -> M {
    return n().multiply(x, y: y);
  }
}

