//
//  Cartesian.swift
//  Swiftz
//
//  Created by Robert Widmann on 5/3/16.
//  Copyright © 2016 TypeLift. All rights reserved.
//

public protocol Cartesian : Functor {
	associatedtype C
	associatedtype FC = K1<C>
	associatedtype D
	associatedtype FD = K1<D>

	associatedtype FTOP = K1<()>
	associatedtype FTAB = K1<(A, B)>
	associatedtype FTABC = K1<(A, B, C)>
	associatedtype FTABCD = K1<(A, B, C, D)>

	static var unit : FTOP { get }
	func product(r : FB) -> FTAB
	func product(r : FB, _ s : FC) -> FTABC
	func product(r : FB, _ s : FC, _ t : FD) -> FTABCD
}
