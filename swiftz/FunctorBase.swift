//
//  FunctorBase.swift
//  swiftz
//
//  Created by Maxwell Swadling on 9/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

// instance Functor ((->) r)
//class Function1<A, B>: F<A> {
//
//}

// instance Functor Id
class Id<A>: F<A> {
  let a: () -> A
  init(_ aa: A) {
    a = { aa }
  }
  func runId() -> A {
    return a()
  }
}

extension Id: Functor {
  typealias B = Any
  func fmap(fn: (A -> B)) -> Id<B> {
    return (Id<B>(fn(self.runId())))
  }
}

// instance Functor (Const m)
class Const<B, A>: F<A> {
  let a: () -> B
  init(_ aa: B) {
    a = { aa }
  }
  func runConst() -> B {
    return a()
  }
}

extension Const: Functor {
  func fmap(fn: (A -> B)) -> Const<B, B> {
    return (Const<B, B>(self.runConst()))
  }
}
