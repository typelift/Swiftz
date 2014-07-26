//
//  Bifunctor.swift
//  swiftz
//
//  Created by Robert Widmann on 7/25/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

public class P<A, B> {
  public init() {
    
  }
}

public protocol Bifunctor {
  typealias A
  typealias B
  typealias C
  typealias D
  typealias PAC = P<A, C>
  typealias PAB = P<A, B>
  typealias PBC = P<B, C>
  typealias PBD = P<B, D>

  func bimap(f: (A -> B), g: (C -> D), x: PAC) -> PBD
}

//func leftMap<A, B, C, PAB : Bifunctor, R : Bifunctor>(f : (A -> B), x: PAB) -> R {
//  return x.bimap(f, g: identity, x: x)
//}
//
//func rightMap<A, B, C, PAB : Bifunctor, PAC : Bifunctor>(f : (A -> B), x: PAB) -> PAC {
//  return x.bimap(identity, g: f, x: x)
//}

public struct ConstBF<A, B, C, D>: Bifunctor {
  public let c: Const<A, B>
  
  public init(m: Const<A, B>) {
    self.c = m
  }
  
  public func bimap(f: (A -> B), g: (C -> D), x: Const<A, C>) -> Const<B, D> {
    return Const(f(x.runConst()))
  }
}

public struct EitherBF<A, B, C, D>: Bifunctor {
  public let e: Either<A, B>
  
  public init(m: Either<A, B>) {
    self.e = m
  }
  
  public func bimap(f: (A -> B), g: (C -> D), x: Either<A, C>) -> Either<B, D> {
    switch x {
      case .Left(let bx): return Either.Left(Box<B>(f(bx.value)))
      case .Right(let bx): return Either.Right(Box<D>(g(bx.value)))
    }
  }
}

public struct TupleBF<A, B, C, D>: Bifunctor {
  public let e: (A, B)
  
  public init(m: (A, B)) {
    self.e = m
  }
  
  public func bimap(f: (A -> B), g: (C -> D), x: (A, C)) -> (B, D) {
    return (f(x.0), g(x.1))
  }
}
