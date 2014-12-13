//
//  Functions.swift
//  swiftz_core
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

// the building blocks of FP

/// The identity function.
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
public func flip<A, B, C>(f: A -> B -> C) -> B -> A -> C {
	return { b in { a in f(a)(b) } }
}

/// Function composition. Alt + 8
/// Given two functions, `f` and `g` returns a function that takes an `A` and returns a `C`.
/// f and g are applied like so: f(g(a))
public func •<A, B, C>(f: B -> C, g: A -> B) -> A -> C {
	return { (a: A) -> C in
		return f(g(a))
	}
}

/// Function application. Alt + 6
/// Applies a function to its argument, i.e., calls the function.
public func §<A, B>(f: A -> B, a: A) -> B {
	return f(a)
}

/// Function application. Synonym for `§`: `f <| a == f § a`.
public func <|<A, B>(f: A -> B, a: A) -> B {
	return f(a)
}

/// Thrush function. Given an A, and a function A -> B, applies the function to A and returns the result
/// can make code more readable
public func |><A, B>(a: A, f: A -> B) -> B {
	return f(a)
}

