//
//  Monad.swift
//  swiftz_core
//
//  Created by Maxwell Swadling on 29/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

/// Monads are Monoids lifted into category theory.
public protocol Monad : Applicative {
	/// Sequences and composes two monadic actions by passing the value inside the monad on the left
	/// to a function on the right yielding a new monad.
	func bind(f : A -> FB) -> FB
}

/// A monoid for monads.
public protocol MonadPlus : Monad {
	static var mzero : Self { get }
	func mplus(_: Self) -> Self
}

/// Monads that admit left-tightening recursion.
public protocol MonadFix : Monad {
	/// Calculates the fixed point of a monadic computation.
	static func mfix(_: A -> Self) -> Self
}
