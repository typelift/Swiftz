//
//  TypeEquality.swift
//  swiftz
//
//  Created by Maxwell Swadling on 19/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

protocol TypeEquality {
  typealias A
  typealias B
  func apply(a: A) -> B
}

@final class Refl<X> : TypeEquality {
  typealias A = X
  typealias B = X
  func apply(a: A) -> B {
    return a
  }
}
