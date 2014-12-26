//
//  Optional.swift
//  swiftz_core
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

/// Lifts a value into an Optional.
public func pure<A>(a: A) -> A? {
	return .Some(a)
}

/// Fmap | If the Optional is None, ignores the function and returns None. If the Optional is Some, 
/// applies the function to the Some value and returns the result in a new Some.
public func <^><A, B>(f: A -> B, a: A?) -> B? {
	if let x = a {
		return (f(x))
	} else {
		return .None
	}
}

/// Ap | Given an Optional<A -> B> and an Optional<A>, returns an Optional<B>. If the `f` or `a' 
/// param is None, simply returns None. Otherwise the function taken from Some(f) is applied to the 
/// value from Some(a) and a Some is returned.
public func <*><A, B>(f: (A -> B)?, a: A?) -> B? {
	if f != nil && a != nil {
		return (f!(a!))
	} else {
		return .None
	}
}

/// Bind | Given an Optional<A>, and a function from A -> Optional<B>, applies the function `f` if 
/// `a` is Some, otherwise the function is ignored and None is returned.
public func >>-<A, B>(a: A?, f: A -> B?) -> B? {
	if let x = a {
		return f(x)
	} else {
		return .None
	}
}
