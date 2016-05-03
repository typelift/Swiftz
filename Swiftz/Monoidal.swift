//
//  Cartesian.swift
//  Swiftz
//
//  Created by Robert Widmann on 5/3/16.
//  Copyright © 2016 TypeLift. All rights reserved.
//

public protocol Cartesian : Functor {
	associatedtype FTOP = K1<()>
	associatedtype FTAB = K1<(A, B)>

	static var unit : FTOP { get }
	func product(r : FB) -> FTAB
}