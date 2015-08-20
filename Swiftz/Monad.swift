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

/// Monads that allow zipping.
public protocol MonadZip : Monad {
	/// An arbitrary domain.  Usually Any.
	typealias C
	/// A monad with an arbitrary domain.
	typealias FC = K1<C>
	
	/// A Monad containing a zipped tuple.
	typealias FTAB = K1<(A, B)>
	
	/// Zip for monads.
	func mzip(_ : FB) -> FTAB
	
	/// ZipWith for monads.
	func mzipWith(_ : FB, _ : A -> B -> C) -> FC
	
	/// Unzip for monads.
	static func munzip(_ : FTAB) -> (Self, FB)
}

/// A monoid for monads.
public protocol MonadPlus : Monad {
	static var mzero : Self { get }
	func mplus(_ : Self) -> Self
}
