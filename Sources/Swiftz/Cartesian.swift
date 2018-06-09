//
//  Cartesian.swift
//  Swiftz
//
//  Created by Robert Widmann on 5/3/16.
//  Copyright © 2016 TypeLift. All rights reserved.
//

/// A `Cartesian` Functor is a Monoidal Functor.  That is, a `Functor` that is
/// equipped with a product function in addition to functorial map.  It is
/// equivalent in power to Applicative Functors.
public protocol Cartesian : Functor {
	associatedtype C
	associatedtype FC = K1<C>
	associatedtype D
	associatedtype FD = K1<D>

	associatedtype FTOP = K1<()>
	associatedtype FTAB = K1<(A, B)>
	associatedtype FTABC = K1<(A, B, C)>
	associatedtype FTABCD = K1<(A, B, C, D)>
	
	/// Returns the unit tuple functor.
	static var unit : FTOP { get }
	
	/// Returns the 2-ary product functor of the receiver and the other given 
	/// functor.
	func product(_ r : FB) -> FTAB
	
	/// Returns the 3-ary product functor of the receiver and the 2 other given 
	/// functors.
	func product(_ r : FB, _ s : FC) -> FTABC
	
	/// Returns the 4-ary product functor of the receiver and the 3 other given 
	/// functors.
	func product(_ r : FB, _ s : FC, _ t : FD) -> FTABCD
}
