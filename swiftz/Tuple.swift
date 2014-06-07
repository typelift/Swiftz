//
//  Tuple.swift
//  swiftz
//
//  Created by Maxwell Swadling on 7/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

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
