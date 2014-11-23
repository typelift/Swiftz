//
//  OptionalExt.swift
//  swiftz
//
//  Created by Maxwell Swadling on 4/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

public func flatMap<A, B>(m : Optional<A>) -> (A -> Optional<B>) -> Optional<B> {
	return { f in maybe(m)(.None)(f) }
}

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

// scala's getOrElse
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
