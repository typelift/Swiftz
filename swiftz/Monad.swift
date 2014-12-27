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
