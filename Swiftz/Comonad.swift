//
//  Comonad.swift
//  swiftz_core
//
//  Created by Maxwell Swadling on 29/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

/// A Comonad is the categorical dual to a Monad.
///
/// "A comonoid in the monoidal category of endofunctors"
public protocol Comonad : Copointed, Functor {
	typealias FFA = K1<Self>

	/// Duplicates the surrounding comonadic context and embeds the receiver in it.
	func duplicate() -> FFA

	/// Duplicates the surrounding comonadic context of the receiver and applies a function to the
	/// receiver to yield a new value in that context.
	func extend(fab : Self -> B) -> FB
}
