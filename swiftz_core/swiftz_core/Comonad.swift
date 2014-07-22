//
//  Comonad.swift
//  swiftz_core
//
//  Created by Maxwell Swadling on 29/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

public protocol Comonad : Functor {
  typealias FAB = F<A> -> B
  func extract() -> A
  func extend(fab: FAB) -> F<B>
}
