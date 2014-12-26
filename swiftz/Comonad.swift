//
//  Comonad.swift
//  swiftz_core
//
//  Created by Maxwell Swadling on 29/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

/// A Comonad is the categorical dual to a Monad.  If a Monad is the model of a computation that
/// produces a value of type T, a Comonad is a value produced from a context.
///
/// "A comonoid in the monoidal category of endofunctors"
public protocol Comonad : Functor {
	/// Uses the surrounding context to compute a value.
	func extract() -> A

	/// Duplicates the surrounding context and computes a value from it while remaining in the 
	/// original context.
	func extend(fab : Self -> B) -> FB
}
