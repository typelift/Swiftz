//
//  Applicative.swift
//  swiftz
//
//  Created by Maxwell Swadling on 15/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

protocol Applicative : Functor {
  typealias FA = F<A>
  typealias FAB = F<A -> B>
  class func pure(a: A) -> FA
  func ap(fn: FAB) -> FB
}

struct MaybeF<A, B>: Functor, Applicative {
  // functor
  let m: Maybe<A>
  func fmap(fn: (A -> B)) -> Maybe<B> {
    if m.isJust() {
      let b: B = fn(m.fromJust())
      return Maybe<B>.just(b)
    } else {
      return Maybe<B>.none()
    }
  }
  
  // applicative
  static func pure(a: A) -> Maybe<A>  {
    return Maybe<A>.just(a)
  }
  
  func ap(fn: Maybe<A -> B>) -> Maybe<B>  {
    if fn.isJust() {
      let f: (A -> B) = fn.fromJust()
      return MaybeF(m: m).fmap(f)
    } else {
      return Maybe<B>.none()
    }
  }
}
