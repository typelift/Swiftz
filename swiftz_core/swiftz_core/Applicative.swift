//
//  Applicative.swift
//  swiftz_core
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
