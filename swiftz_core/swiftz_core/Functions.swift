//
//  Functions.swift
//  swiftz_core
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

// the building blocks of FP

// Identity function
func identity<A>(a: A) -> A {
  return a;
}

// Fip a function's arguments
func flip<A, B, C>(f: ((A, B) -> C), b: B, a: A) -> C {
  return f(a, b)
}

// Function composition. Alt + 8
func •<A, B, C>(f: B -> C, g: A -> B) -> A -> C {
  return { (a: A) -> C in
    return f(g(a))
  }
}

// Thrush
func |><A, B>(a: A, f: A -> B) -> B {
  return f(a)
}

// Unsafe tap
// Warning: Unstable rdar://17109199
//func <|<A>(a: A, f: A -> Any) -> A {
//  f(a)
//  return a
//}
