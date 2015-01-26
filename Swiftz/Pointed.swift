//
//  Pointed.swift
//  swiftz
//
//  Created by Robert Widmann on 1/8/15.
//  Copyright (c) 2015 Maxwell Swadling. All rights reserved.
//

/// Functors equipped with a point taking values to instances of themselves.
public protocol Pointed {
	typealias A
	class func pure(A) -> Self
}

extension Box : Pointed {
	public class func pure(x : T) -> Box<T> {
		return Box(x)
	}
}

extension Result : Pointed {
	typealias A = V

	public static func pure(x : V) -> Result<V> {
		return Result.value(x)
	}
}

extension Either : Pointed {
	typealias A = R

	public static func pure(r : R) -> Either<L, R> {
		return Either.right(r)
	}
}

extension Set : Pointed {
	public static func pure(x : A) -> Set<A> {
		return Set(arrayLiteral: x)
	}
}
