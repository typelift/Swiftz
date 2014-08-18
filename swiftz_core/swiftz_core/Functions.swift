//
//  Functions.swift
//  swiftz_core
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

// the building blocks of FP

/// The identity function, which returns its argument.
///
/// This can be used to prove to the typechecker that a given type A is
/// equivalent to a given type B.
///
/// For example, the following global function is normally impossible to bring
/// into the `Signal<T>` class:
///
///     func merge<U>(signal: Signal<Signal<U>>) -> Signal<U>
///
/// However, you can work around this restriction using an instance method with
/// an “evidence” parameter:
///
///     func merge<U>(evidence: Signal<T> -> Signal<Signal<U>>) -> Signal<U>
///
/// Which would then be invoked with the identity function, like this:
///
///     signal.merge(identity)
///
/// This will verify that `signal`, which is nominally `Signal<T>`, is logically
/// equivalent to `Signal<Signal<U>>`. If that's not actually the case, a type
/// error will result.
public func identity<A>(a: A) -> A {
  return a;
}

/// Flip a function's arguments
public func flip<A, B, C>(f: ((A, B) -> C), b: B, a: A) -> C {
  return f(a, b)
}

/// Flip a function's arguments and return a function that takes
/// the arguments in flipped order.
public func flip<A, B, C>(f: (A, B) -> C)(b: B, a: A) -> C {
  return f(a, b)
}

/// Flip a function's arguments and return a curried function that takes
/// the arguments in flipped order.
public func flip<A, B, C>(f: A -> B -> C)(b: B)(a: A) -> C {
  return f(a)(b)
}

/// Function composition. Alt + 8
/// Given two functions, `f` and `g` returns a function that takes an `A` and returns a `C`.
/// f and g are applied like so: f(g(a))
public func •<A, B, C>(f: B -> C, g: A -> B) -> A -> C {
  return { (a: A) -> C in
    return f(g(a))
  }
}

/// Thrush function. Given an A, and a function A -> B, applies the function to A and returns the result
/// can make code more readable
public func |><A, B>(a: A, f: A -> B) -> B {
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
public func <^><I, A, B>(f: A -> B, k: I -> A) -> (I -> B) {
  return { x in
    f(k(x))
  }
}

// flip(•)
public func <!><I, J, A>(f: J -> I, k: I -> A) -> (J -> A) {
  return { x in
    k(f(x))
  }
}

// the S combinator
public func <*><I, A, B>(f: I -> (A -> B), k: I -> A) -> (I -> B) {
  return { x in
    f(x)(k(x))
  }
}

// the S' combinator
public func >>=<I, A, B>(f: A -> (I -> B), k: I -> A) -> (I -> B) {
  return { x in
    f(k(x))(x)
  }
}
