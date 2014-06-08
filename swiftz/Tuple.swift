//
//  Tuple.swift
//  swiftz
//
//  Created by Maxwell Swadling on 7/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

// the standard library has _.1, _.2 functions
// these functions are more useful when "doing fp"
func fst<A, B>(ab: (A, B)) -> A {
  switch ab {
    case let (a, b): return a
  }
}

func snd<A, B>(ab: (A, B)) -> A {
  switch ab {
    case let (a, b): return a
  }
}
