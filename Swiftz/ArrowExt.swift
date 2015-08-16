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

/// Fmap | Function composition.
public func <^> <A, B, R>(f : A -> B, g : R -> A) -> (R -> B) {
	return f • g
}

// MARK: - Control.Applicative

/// Ap | "Share Environment"
public func <*> <A, B, R>(f : (R -> (A -> B)), g : (R -> A)) -> (R -> B) {
	return { x in f(x)(g(x)) }
}

/// Bind | "Kontinue Environment"
public func >>- <A, B, R>(f : (R -> A), k : (A -> (R -> B))) -> (R -> B) {
	return { r in k(f(r))(r) }
}
