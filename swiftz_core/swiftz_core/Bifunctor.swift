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
  
  func bimap(f: (A -> B), g: (C -> D)) -> PBD
}

// TODO: Collapse Bifunctor instances so [left/right]Map typecheck
//public func leftMap<A, B, C, PAC : Bifunctor, PBC : Bifunctor where PAC.A == A, PAC.B == B, PAC.C == C, PAC.D == C, PBC.A == A, PBC.B == B, PBC.C == C, PBC.D == C, PBC == PAC.PBD>
//  (x: PAC, f : (A -> B)) -> PBC {
//  return x.bimap(f, g: identity)
//}
//
//public func rightMap<A, B, C, D, PAC : Bifunctor, PAD : Bifunctor where PAC.A == A, PAC.B == A, PAC.C == C, PAC.D == D, PAD.A == A, PAD.B == A, PAD.C == C, PAD.D == D, PAD == PAC.PBD>
//  (x: PAC, g : (C -> D)) -> PAD {
//  return x.bimap(identity, g: g)
//}

public struct ConstBF<A, B, C, D>: Bifunctor {
  public let c: Const<A, C>
  
  public init(_ c: Const<A, C>) {
    self.c = c
  }
  
  public func bimap(f: (A -> B), g: (C -> D)) -> Const<B, D> {
    return Const(f(c.runConst()))
  }
}

public struct EitherBF<A, B, C, D>: Bifunctor {
  public let e: Either<A, C>
  
  public init(_ e: Either<A, C>) {
    self.e = e
  }
  
  public func bimap(f: (A -> B), g: (C -> D)) -> Either<B, D> {
    switch e {
      case .Left(let bx): return Either.Left(Box<B>(f(bx.value)))
      case .Right(let bx): return Either.Right(Box<D>(g(bx.value)))
    }
  }
}

public struct TupleBF<A, B, C, D>: Bifunctor {
  public let t: (A, C)
  
  public init(_ t: (A, C)) {
    self.t = t
  }
  
  public func bimap(f: (A -> B), g: (C -> D)) -> (B, D) {
    return (f(t.0), g(t.1))
  }
}
