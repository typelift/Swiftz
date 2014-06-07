//
//  Curry.swift
//  swiftz
//
//  Created by Maxwell Swadling on 7/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

func curry<A, B, C>(f: (A, B) -> C, a: A, b: B) -> C {
  return f((a, b))
}

func uncurry<A, B, C>(f: (A -> (B -> C)), ab: (A, B)) -> C {
  switch ab {
  case let (a, b): return (f(a)(b))
  }
}

func curry<A, B, C, D>(f: (A, B, C) -> D, a: A, b: B, c: C) -> D {
  return f((a, b, c))
}

func uncurry<A, B, C, D>(f: (A -> (B -> (C -> D))), abc: (A, B, C)) -> D {
  switch abc {
  case let (a, b, c): return (f(a)(b)(c))
  }
}

func curry<A, B, C, D, E>(f: (A, B, C, D) -> E, a: A, b: B, c: C, d: D) -> E {
  return f((a, b, c, d))
}

func uncurry<A, B, C, D, E>(f: (A -> (B -> (C -> (D -> E)))), abcd: (A, B, C, D)) -> E {
  switch abcd {
  case let (a, b, c, d): return (f(a)(b)(c)(d))
  }
}
