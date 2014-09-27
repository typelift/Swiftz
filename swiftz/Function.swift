//
//  Function.swift
//  swiftz
//
//  Created by Robert Widmann on 9/26/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Basis

// functions as a monad and profunctor

// •
public func <%><I, A, B>(f: A -> B, k: I -> A) -> (I -> B) {
  return { x in
    f(k(x))
  }
}

// flip(•)
public func <!><I, J, A>(f: J -> I, k: I -> A) -> (J -> A) {
  return { x in
    k(f(x))
  }
}

// the S combinator
public func <*><I, A, B>(f: I -> (A -> B), k: I -> A) -> (I -> B) {
  return { x in
    f(x)(k(x))
  }
}

// the S' combinator
public func >>-<I, A, B>(f: A -> (I -> B), k: I -> A) -> (I -> B) {
  return { x in
    f(k(x))(x)
  }
}
