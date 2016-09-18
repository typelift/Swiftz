//
//  Functor.swift
//  Swiftz
//
//  Created by Josh Abernathy on 6/7/2014.
//  Copyright (c) 2014-2016 Josh Abernathy. All rights reserved.
//

/// Functors are mappings from the functions and objects in one set to the functions and objects
/// in another set.
public protocol Functor {
	/// Source
	associatedtype A
	/// Target
	associatedtype B
	/// A Target Functor
	associatedtype FB = K1<B>

	/// Map a function over the value encapsulated by the Functor.
	func fmap(_ f : (A) -> B) -> FB
}
