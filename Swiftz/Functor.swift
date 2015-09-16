//
//  Functor.swift
//  Swiftz
//
//  Created by Josh Abernathy on 6/7/2014.
//  Copyright (c) 2014 Josh Abernathy. All rights reserved.
//

/// Functors are mappings from the functions and objects in one set to the functions and objects
/// in another set.
public protocol Functor {
	/// Source
	typealias A
	/// Target
	typealias B
	/// A Target Functor
	typealias FB = K1<B>

	/// Map a function over the value encapsulated by the Functor.
	func fmap(f : A -> B) -> FB
}
