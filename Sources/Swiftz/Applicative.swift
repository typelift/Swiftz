//
//  Applicative.swift
//  Swiftz
//
//  Created by Maxwell Swadling on 15/06/2014.
//  Copyright (c) 2014-2016 Maxwell Swadling. All rights reserved.
//

/// Applicative sits in the middle distance between a Functor and a Monad.  An 
/// Applicative Functor is a Functor equipped with a function (called point or 
/// pure) that takes a value to an instance of a functor containing that value. 
/// Applicative Functors provide the ability to operate on not just values, but 
/// values in a functorial context such as Eithers, Lists, and Optionals without
/// needing to unwrap or map over their contents.
public protocol Applicative : Pointed, Functor {
	/// Type of Functors containing morphisms from our objects to a target.
	associatedtype FAB = K1<(A) -> B>

	/// Applies the function encapsulated by the Functor to the value 
	/// encapsulated by the receiver.
	func ap(_ f : FAB) -> FB
}

/// Additional functions to be implemented by those types conforming to the 
/// Applicative protocol.
public protocol ApplicativeOps : Applicative {
	associatedtype C
	associatedtype FC = K1<C>
	associatedtype D
	associatedtype FD = K1<D>

	/// Lift a function to a Functorial action.
	static func liftA(_ f : @escaping (A) -> B) -> (Self) -> FB

	/// Lift a binary function to a Functorial action.
	static func liftA2(_ f : @escaping (A) -> (B) -> C) -> (Self) -> (FB) -> FC

	/// Lift a ternary function to a Functorial action.
	static func liftA3(_ f : @escaping (A) -> (B) -> (C) -> D) -> (Self) -> (FB) -> (FC) -> FD
}
