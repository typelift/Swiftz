//
//  TupleExt.swift
//  swiftz
//
//  Created by Maxwell Swadling on 7/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

// the standard library has _.1, _.2 functions
// these functions are more useful when "doing fp" (point-free-ish forms)
public func fst<A, B>(ab: (A, B)) -> A {
  switch ab {
    case let (a, _): return a
  }
}

public func fst<A, B, C>() -> Lens<(A, C), (B, C), A, B> {
  return Lens { (x, y) in IxStore(x) { ($0, y) } }
}

public func snd<A, B>(ab: (A, B)) -> B {
  switch ab {
    case let (_, b): return b
  }
}

public func snd<A, B, C>() -> Lens<(A, B), (A, C), B, C> {
  return Lens { (x, y) in IxStore(y) { (x, $0) } }
}

//Not possible to extend like this currently.
//extension () : Equatable {}
//extension (T:Equatable, U:Equatable) : Equatable {}


@infix public func ==(lhs: (), rhs: ()) -> Bool {
  return true
}
@infix public func !=(lhs: (), rhs: ()) -> Bool { return false }

// Unlike Python a 1-tuple is just it's contained element.

@infix public func == <T:Equatable,U:Equatable>(lhs: (T,U), rhs: (T,U)) -> Bool {
    let (l0,l1) = lhs
    let (r0,r1) = rhs
    return l0 == r0 && l1 == r1
}
@infix public func != <T:Equatable,U:Equatable>(lhs: (T,U), rhs: (T,U)) -> Bool {
  return !(lhs==rhs)
}

@infix public func == <T:Equatable,U:Equatable,V:Equatable>(lhs: (T,U,V), rhs: (T,U,V)) -> Bool {
    let (l0,l1,l2) = lhs
    let (r0,r1,r2) = rhs
    return l0 == r0 && l1 == r1 && l2 == r2
}
@infix public func != <T:Equatable,U:Equatable,V:Equatable>(lhs: (T,U,V), rhs: (T,U,V)) -> Bool {
  return !(lhs==rhs)
}

@infix public func == <T:Equatable,U:Equatable,V:Equatable,W:Equatable>(lhs: (T,U,V,W), rhs: (T,U,V,W)) -> Bool {
    let (l0,l1,l2,l3) = lhs
    let (r0,r1,r2,r3) = rhs
    return l0 == r0 && l1 == r1 && l2 == r2 && l3 == r3
}
@infix public func != <T:Equatable,U:Equatable,V:Equatable,W:Equatable>(lhs: (T,U,V,W), rhs: (T,U,V,W)) -> Bool {
  return !(lhs==rhs)
  }
@infix public func == <T:Equatable,U:Equatable,V:Equatable,W:Equatable,X:Equatable>(lhs: (T,U,V,W,X), rhs: (T,U,V,W,X)) -> Bool {
    let (l0,l1,l2,l3,l4) = lhs
    let (r0,r1,r2,r3,r4) = rhs
    return l0 == r0 && l1 == r1 && l2 == r2 && l3 == r3 && l4 == r4
}
@infix public func != <T:Equatable,U:Equatable,V:Equatable,W:Equatable,X:Equatable>(lhs: (T,U,V,W,X), rhs: (T,U,V,W,X)) -> Bool {
  return !(lhs==rhs)
}
@infix public func == <T:Equatable,U:Equatable,V:Equatable,W:Equatable,X:Equatable,Z:Equatable>(lhs: (T,U,V,W,X,Z), rhs: (T,U,V,W,X,Z)) -> Bool {
    let (l0,l1,l2,l3,l4,l5) = lhs
    let (r0,r1,r2,r3,r4,r5) = rhs
    return l0 == r0 && l1 == r1 && l2 == r2 && l3 == r3 && l4 == r4 && l5 == r5
}
@infix public func != <T:Equatable,U:Equatable,V:Equatable,W:Equatable,X:Equatable,Z:Equatable>(lhs: (T,U,V,W,X,Z), rhs: (T,U,V,W,X,Z)) -> Bool {
  return !(lhs==rhs)
}
