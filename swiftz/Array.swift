//
//  Array.swift
//  swiftz_core
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

/// Applicative `pure` function, lifts a value into an Array.
public func pure<A>(a: A) -> [A] {
  return [a]
}

/// Functor `fmap`. This is the same as calling a.map(f).
public func <^><A, B>(f: A -> B, a: [A]) -> [B] {
  return a.map(f)
}

/// Applicative Functor `apply`. Given an [A -> B] and an [A],
/// returns a [B]. Applies the function at each index in `f` to every
/// index in `a` and retuns the results in a new array.
public func <*><A, B>(f: [(A -> B)], a: [A]) -> [B] {
  var re = [B]()
  for g in f {
    for h in a {
      re.append(g(h))
    }
  }
  return re
}

/// Monadic `bind`. Given an [A], and a function from A -> [B],
/// applies the function `f` to every element in [A] and returns the result.
public func >>-<A, B>(a: [A], f: A -> [B]) -> [B] {
  var re = [B]()
  for x in a {
    re.extend(f(x))
  }
  return re
}
