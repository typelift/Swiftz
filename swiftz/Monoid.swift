//
//  Monoid.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

public protocol Monoid: Semigroup {
  func mzero() -> M
}

public func mconcat<M, S: Monoid where S.M == M>(s: S, t: [M]) -> M {
  return (t.reduce(s.mzero()) { s.op($0, y: $1) })
}

public class Sum<A, N: Num where N.N == A>: Monoid {
  public typealias M = A
  let n: () -> N // work around for rdar://17109323
  
  // explicit instance passing
  public init(i: () -> N) {
    n = i
  }
  
  public func mzero() -> M { return n().zero() }
  public func op(x: M, y: M) -> M {
    return n().add(x, y: y);
  }
}

public class Product<A, N: Num where N.N == A>: Monoid {
  public typealias M = A
  let n: () -> N
  public init(i: () -> N) {
    n = i
  }
  public func mzero() -> M { return n().succ(n().zero()) }
  public func op(x: M, y: M) -> M {
    return n().multiply(x, y: y);
  }
}

