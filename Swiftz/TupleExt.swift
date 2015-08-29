//
//  TupleExt.swift
//  Swiftz
//
//  Created by Maxwell Swadling on 7/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

/// Extracts the first value from a pair.
public func fst<A, B>(ab : (A, B)) -> A {
	return ab.0
}

/// Extracts the second value from a pair.
public func snd<A, B>(ab : (A, B)) -> B {
	return ab.1
}

//Not possible to extend like this currently.
//extension () : Equatable {}
//extension (T:Equatable, U:Equatable) : Equatable {}


public func ==(lhs: (), rhs: ()) -> Bool {
	return true
}

public func !=(lhs: (), rhs: ()) -> Bool { return false }

// Unlike Python a 1-tuple is just it's contained element.

public func == <T:Equatable,U:Equatable>(lhs: (T,U), rhs: (T,U)) -> Bool {
	let (l0,l1) = lhs
	let (r0,r1) = rhs
	return l0 == r0 && l1 == r1
}

public func != <T:Equatable,U:Equatable>(lhs: (T,U), rhs: (T,U)) -> Bool {
	return !(lhs==rhs)
}

public func == <T:Equatable,U:Equatable,V:Equatable>(lhs: (T,U,V), rhs: (T,U,V)) -> Bool {
	let (l0,l1,l2) = lhs
	let (r0,r1,r2) = rhs
	return l0 == r0 && l1 == r1 && l2 == r2
}

public func != <T:Equatable,U:Equatable,V:Equatable>(lhs: (T,U,V), rhs: (T,U,V)) -> Bool {
	return !(lhs==rhs)
}

public func == <T:Equatable,U:Equatable,V:Equatable,W:Equatable>(lhs: (T,U,V,W), rhs: (T,U,V,W)) -> Bool {
	let (l0,l1,l2,l3) = lhs
	let (r0,r1,r2,r3) = rhs
	return l0 == r0 && l1 == r1 && l2 == r2 && l3 == r3
}

public func != <T:Equatable,U:Equatable,V:Equatable,W:Equatable>(lhs: (T,U,V,W), rhs: (T,U,V,W)) -> Bool {
	return !(lhs==rhs)
}

public func == <T:Equatable,U:Equatable,V:Equatable,W:Equatable,X:Equatable>(lhs: (T,U,V,W,X), rhs: (T,U,V,W,X)) -> Bool {
	let (l0,l1,l2,l3,l4) = lhs
	let (r0,r1,r2,r3,r4) = rhs
	return l0 == r0 && l1 == r1 && l2 == r2 && l3 == r3 && l4 == r4
}

public func != <T:Equatable,U:Equatable,V:Equatable,W:Equatable,X:Equatable>(lhs: (T,U,V,W,X), rhs: (T,U,V,W,X)) -> Bool {
	return !(lhs==rhs)
}

public func == <T:Equatable,U:Equatable,V:Equatable,W:Equatable,X:Equatable,Z:Equatable>(lhs: (T,U,V,W,X,Z), rhs: (T,U,V,W,X,Z)) -> Bool {
	let (l0,l1,l2,l3,l4,l5) = lhs
	let (r0,r1,r2,r3,r4,r5) = rhs
	return l0 == r0 && l1 == r1 && l2 == r2 && l3 == r3 && l4 == r4 && l5 == r5
}

public func != <T:Equatable,U:Equatable,V:Equatable,W:Equatable,X:Equatable,Z:Equatable>(lhs: (T,U,V,W,X,Z), rhs: (T,U,V,W,X,Z)) -> Bool {
	return !(lhs==rhs)
}
