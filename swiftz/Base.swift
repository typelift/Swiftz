//
//  Base.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

func identity<A>(a: A) -> A {
  return a;
}

func curry<A, B, C>(f: (A, B) -> C, a: A, b: B) -> C {
  return f((a, b))
}

func uncurry<A, B, C>(f: (A -> (B -> C)), ab: (A, B)) -> C {
  switch ab {
    case let (a, b): return (f(a)(b))
  }
}
