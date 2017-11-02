//
//  Category.swift
//  Swiftz
//
//  Created by Robert Widmann on 1/18/15.
//  Copyright (c) 2015-2016 TypeLift. All rights reserved.
//

#if !XCODE_BUILD
	import Operadics
#endif

/// A Category is an algebraic structure consisting of a set of objects and a 
/// set of morphisms between those objects.  Each object includes an identity 
/// morphism, and composition of morphisms is the primary reason categories are 
/// such powerful abstractions.
///
/// Here, a Category is some class of Kind * -> * -> * that you can think of as 
/// modelling an "arrow" A -> B.  This means that if we provide a composition 
/// function, `•`, we can hook up Categories from A -> B with Categories
/// B -> C and get Categories A -> C.  This function is also called >>>.
public protocol Category {
	/// Source
	associatedtype A
	/// Target
	associatedtype B
	/// Other Target; Usually Any.
	associatedtype C

	/// The identity category
	associatedtype CAA = K2<A, A>
	/// A Category we can compose with.
	associatedtype CBC = K2<B, C>
	/// The composition of this Category with the Category above.
	associatedtype CAC = K2<A, C>

	/// The identity morphism.
	static func id() -> CAA

	/// Composition of categories.
	///
	/// If you peek behind the types, it's just plain old composition.
	static func •(c : CBC, c2 : Self) -> CAC

	/// Right-to-left composition.
	static func >>> (_ : Self, _ : CBC) -> CAC

	/// Left-to-right composition.
	///
	/// Usually an alias for •
	static func <<< (_ : CBC, _ : Self) -> CAC
}
