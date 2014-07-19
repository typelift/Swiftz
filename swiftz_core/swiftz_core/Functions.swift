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
func flip<A, B, C>(f: (A, B) -> C)(b: B, a: A) -> C {
  return f(a, b)
}
func flip<A, B, C>(f: A -> B -> C)(b: B)(a: A) -> C {
  return f(a)(b)
}

// Function composition. Alt + 8
@infix func •<A, B, C>(f: B -> C, g: A -> B) -> A -> C {
  return { (a: A) -> C in
    return f(g(a))
  }
}

// Thrush
@infix func |><A, B>(a: A, f: A -> B) -> B {
  return f(a)
}

// Unsafe tap
// Warning: Unstable rdar://17109199
//func <|<A>(a: A, f: A -> Any) -> A {
//  f(a)
//  return a
//}

// functions as a monad and profunctor

// •
@infix func <^><I, A, B>(f: A -> B, k: I -> A) -> (I -> B) {
  return { x in
    f(k(x))
  }
}

// flip(•)
@infix func <!><I, J, A>(f: J -> I, k: I -> A) -> (J -> A) {
  return { x in
    k(f(x))
  }
}

// the S combinator
@infix func <*><I, A, B>(f: I -> (A -> B), k: I -> A) -> (I -> B) {
  return { x in
    f(x)(k(x))
  }
}

// the S' combinator
@infix func >>=<I, A, B>(f: A -> (I -> B), k: I -> A) -> (I -> B) {
  return { x in
    f(k(x))(x)
  }
}
