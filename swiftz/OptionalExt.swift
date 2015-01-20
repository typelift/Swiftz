//
//  OptionalExt.swift
//  swiftz
//
//  Created by Maxwell Swadling on 4/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

/// Applies a function to the contents of an Optional to yield a new Optional.  If no value exists
/// the result of this function is None.
public func flatMap<A, B>(m : Optional<A>) -> (A -> Optional<B>) -> Optional<B> {
	return { f in maybe(m)(.None)(f) }
}

/// Case analysis for the Maybe type.  Given a maybe, a default value in case it is None, and
/// a function, maps the function over the value in the Maybe.
public func maybe<A, B>(m : Optional<A>) -> B -> (A -> B) -> B {
	return { z in { f in
		switch m {
		case .None: 
			return z
		case let .Some(x): 
			return f(x)
		}
	} }
}

/// Given an Optional and a default value returns the value of the Optional when it is Some, else
/// this function returns the default value.
public func getOrElse<T>(m : Optional<T>) -> T -> T {
	return { def in
		switch m {
		case .None: 
			return def
		case let .Some(x): 
			return x
		}
	}
}
