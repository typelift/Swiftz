//
//  Functor.swift
//  swiftz_core
//
//  Created by Josh Abernathy on 6/7/2014.
//  Copyright (c) 2014 Josh Abernathy. All rights reserved.
//

import Foundation


public protocol Functor {
  typealias A
  typealias B
  typealias FB = K1<B>
  func fmap(f: (A -> B)) -> FB
}

// TODO: instance Functor ((->) r)
//class Function1<A, B>: F<A> {
//
//}

// instance Functor Id
public final class Id<A>: K1<A> {
  private let a: () -> A
  public init(_ aa: A) {
    a = { aa }
  }
  public var runId: A {
    return a()
  }
}

extension Id: Functor {
  public typealias B = Any
  public func fmap(f: (A -> B)) -> Id<B> {
    return (Id<B>(f(self.runId)))
  }
}

// instance Functor (Const m)
public final class Const<B, A>: K1<A> {
  private let a: () -> B
  public init(_ aa: B) {
    a = { aa }
  }
  public var runConst: B {
    return a()
  }
}

extension Const: Functor {
  public func fmap(f: (A -> B)) -> Const<B, B> {
    return (Const<B, B>(self.runConst))
  }
}
