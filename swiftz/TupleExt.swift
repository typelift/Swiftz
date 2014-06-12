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
func fst<A, B>(ab: (A, B)) -> A {
  switch ab {
    case let (a, _): return a
  }
}

//func fst<A, B, C>() -> Lens<(A, C), (B, C), A, B> {
//     return Lens { (x, y) in (x, { ($0, y) }) }
//}

func snd<A, B>(ab: (A, B)) -> B {
  switch ab {
    case let (_, b): return b
  }
}

//func snd<A, B, C>() -> Lens<(A, B), (A, C), B, C> {
//     return Lens { (x, y) in (y, { (x, $0) }) }
//}
