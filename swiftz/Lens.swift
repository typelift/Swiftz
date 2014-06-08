//
//  Lens.swift
//  swiftz
//
//  Created by Maxwell Swadling on 8/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

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

class Lens<A, B> {
  typealias LensConst = (B -> Const<B, A>) -> A -> Const<B, A>
  typealias LensId = (B -> Id<B>) -> A -> Id<A>
  
  class func get(lens: LensConst, _ a: A) -> B {
    return (lens({ (b: B) -> Const<B, A> in return Const<B, A>(b) })(a)).runConst()
  }
  
  class func set(lens: LensId, _ b: B, _ a: A) -> A {
    return lens({ (_: B) -> Id<B> in return Id<B>(b) })(a).runId()
  }
  
  class func modify(lens: LensId, _ f: (B -> B), _ a: A) -> A {
    return lens({ (b: B) -> Id<B> in return Id<B>(f(b)) })(a).runId()
  }
}
