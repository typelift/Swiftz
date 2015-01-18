//
//  Applicative.swift
//  swiftz_core
//
//  Created by Maxwell Swadling on 15/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

/// Applicative sits in the middle distance between a Functor and a Monad.  An Applicative Functor
/// is a Functor equipped with a function (called point or pure) that takes a value to an instance
/// of a functor containing that value. Applicative Functors provide the ability to operate on not
/// just values, but values in a functorial context such as Eithers, Lists, and Optionals without
/// needing to unwrap or map over their contents.
public protocol Applicative : Pointed, Functor {
	/// Type of Functors containing morphisms from our objects to a target.
	typealias FAB = K1<A -> B>

	/// Applies the function encapsulated by the Functor to the encapsulated by the receiver.
	func ap(f : FAB) -> FB
}
