//
//  TypeEquality.swift
//  swiftz
//
//  Created by Maxwell Swadling on 19/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

// find more info at http://hackage.haskell.org/package/type-equality-0.1.2/docs/Data-Type-Equality.html

protocol TypeEquality {
  typealias A
  typealias B
  func apply(a: A) -> B
}

// Always provide X.
@final class Refl<X> : TypeEquality {
  typealias A = X
  typealias B = X
  func apply(a: A) -> B {
    return a
  }
}
