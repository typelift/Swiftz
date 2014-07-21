//
//  Optional.swift
//  swiftz_core
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

// Functions to make working with Optional easy.

public func pure<A>(a: A) -> A? {
  return a
}

@infix public func <^><A, B>(f: A -> B, a: A?) -> B? {
  if let x = a {
    return (f(x))
  } else {
    return .None
  }
}

@infix public func <*><A, B>(f: (A -> B)?, a: A?) -> B? {
  if f && a {
    return (f!(a!))
  } else {
    return .None
  }
}

// the "if the arg is Some, apply the function that returns an optional
// value and if the arg is None, just return None" function.
@infix public func >>=<A, B>(a: A?, f: A -> B?) -> B? {
  if let x = a {
    return f(x)
  } else {
    return .None
  }
}
