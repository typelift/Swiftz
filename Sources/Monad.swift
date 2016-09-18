//
//  Monad.swift
//  Swiftz
//
//  Created by Maxwell Swadling on 29/06/2014.
//  Copyright (c) 2014-2016 Maxwell Swadling. All rights reserved.
//

/// Monads are Monoids lifted into category theory.
public protocol Monad : Applicative {
	/// Sequences and composes two monadic actions by passing the value inside
	/// the monad on the left to a function on the right yielding a new monad.
	func bind(_ f : (A) -> FB) -> FB
}

public protocol MonadOps : Monad {
	associatedtype C
	associatedtype FC = K1<C>
	associatedtype D
	associatedtype FD = K1<D>

	/// Lift a function to a Monadic action.
	static func liftM(_ f : @escaping (A) -> B) -> (Self) -> FB

	/// Lift a binary function to a Monadic action.
	static func liftM2(_ f : @escaping (A) -> (B) -> C) -> (Self) -> (FB) -> FC

	/// Lift a ternary function to a Monadic action.
	static func liftM3(_ f : @escaping (A) -> (B) -> (C) -> D) -> (Self) -> (FB) -> (FC) -> FD

	// static func >>->> (_ : (A) -> FB, _ : (B) -> FC) -> ((A) -> FC)
	// static func <<-<< (_ : (B) -> FC, _ : (A) -> FB) -> ((A) -> FC)
}

/// Monads that allow zipping.
public protocol MonadZip : Monad {
	/// An arbitrary domain.  Usually Any.
	associatedtype C
	/// A monad with an arbitrary domain.
	associatedtype FC = K1<C>

	/// A Monad containing a zipped tuple.
	associatedtype FTABL = K1<(A, B)>

	/// Zip for monads.
	func mzip(_ : FB) -> FTABL

	/// ZipWith for monads.
	func mzipWith(_ : FB, _ : (A) -> (B) -> C) -> FC

	/// Unzip for monads.
	static func munzip(_ : FTABL) -> (Self, FB)
}

/// A monoid for monads.
public protocol MonadPlus : Monad {
	static var mzero : Self { get }
	func mplus(_ : Self) -> Self
}
