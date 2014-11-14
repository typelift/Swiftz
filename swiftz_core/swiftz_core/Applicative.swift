//
//  Applicative.swift
//  swiftz_core
//
//  Created by Maxwell Swadling on 15/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

public protocol Applicative : Functor {
  typealias FA = K1<A>
  typealias FAB = K1<A -> B>
  class func pure(a: A) -> FA
  func ap(f: FAB) -> FB
}
