//
//  TupleExt.swift
//  Swiftz
//
//  Created by Maxwell Swadling on 7/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

/// Extracts the first value from a pair.
public func fst<A, B>(_ ab : (A, B)) -> A {
	return ab.0
}

/// Extracts the second value from a pair.
public func snd<A, B>(_ ab : (A, B)) -> B {
	return ab.1
}

//Not possible to extend like this currently.
//extension () : Equatable {}
//extension (T:Equatable, U:Equatable) : Equatable {}


public func ==(lhs: (), rhs: ()) -> Bool {
	return true
}

public func !=(lhs: (), rhs: ()) -> Bool { return false }
