//
//  ArrowExt.swift
//  Swiftz
//
//  Created by Robert Widmann on 8/16/15.
//  Copyright © 2015 TypeLift. All rights reserved.
//

// MARK: - Control.Arrow

/// Right-to-Left Function Composition | Function composition.
public func <<< <A, B, C>(f : (B -> C), g : (A -> B)) -> (A -> C) {
	return f • g
}

/// Left-to-Right Function Composition | Function composition, backwards.
public func >>> <A, B, C>(f : (A -> B), g : (B -> C)) -> (A -> C) {
	return g • f
}

// MARK: - Data.Functor

/// Fmap | Returns a function that applies the given transformation to any arguments drawn from its
/// environment.
///
/// Function composition.
public func <^> <A, B, R>(f : A -> B, g : R -> A) -> (R -> B) {
	return f • g
}

// MARK: - Control.Applicative

/// Ap | Uses the latter function to draw an argument from the environment that is then applied to
/// the former function.
///
/// "Share Environment"
public func <*> <A, B, R>(f : (R -> (A -> B)), g : (R -> A)) -> (R -> B) {
	return { x in f(x)(g(x)) }
}

// MARK: - Control.Monad

/// Bind | Draws a value from the environment, applies it to the continuation, then returns the
/// result of the application.
///
/// "Kontinue Environment"
public func >>- <A, B, R>(f : (R -> A), k : (A -> (R -> B))) -> (R -> B) {
	return { r in k(f(r))(r) }
}
