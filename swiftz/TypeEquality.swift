//
//  TypeEquality.swift
//  swiftz
//
//  Created by Maxwell Swadling on 19/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

// WARNING: A current bug in the type checker means using TypeEquality can
// cause type errors to bypass the type checker.
// See https://github.com/maxpow4h/swiftz/issues/45 for more information.
// Instead, it is recommended to use the `identity` function for evidence.
// find more info at http://hackage.haskell.org/package/type-equality-0.1.2/docs/Data-Type-Equality.html
protocol TypeEquality {
  typealias A
  typealias B
  func apply(a: A) -> B
}

struct Refl<X> : TypeEquality {
  typealias A = X
  typealias B = X
  func apply(a: A) -> B {
    return a
  }
}
