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
	static func pure(A) -> Self
}

extension Result : Pointed {
	public static func pure(x : V) -> Result<V> {
		return Result.value(x)
	}
}

extension Either : Pointed {
	typealias A = R

	public static func pure(r : R) -> Either<L, R> {
		return Either.Right(r)
	}
}
