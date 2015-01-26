//
//  Semigroup.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

/// A Semigroup is a type with a closed, associative, binary operator.
public protocol Semigroup {
	/// The type of elements in the semigroup.
	typealias M

	/// An associative binary operator.
	func op(x : M, y : M) -> M
}

public func sconcat<M, S: Semigroup where S.M == M>(s : S, h : M, t : [M]) -> M {
	return (t.reduce(h) { s.op($0, y: $1) })
}

/// The Semigroup of comparable values under MIN().
public struct Min<A: Comparable>: Semigroup {
	public typealias M = A

	public init() { }

	public func op(x : M, y : M) -> M {
		if x < y {
			return x
		} else {
			return y
		}
	}
}

/// The Semigroup of comparable values under MAX().
public struct Max<A: Comparable> : Semigroup {
	public typealias M = A

	public init() { }

	public func op(x : M, y : M) -> M {
		if x > y {
			return x
		} else {
			return y
		}
	}
}

/// The left-biased Maybe Semigroup.
public struct First<A: Comparable> : Semigroup {
	public typealias M = Maybe<A>

	public init() { }

	public func op(x : M, y : M) -> M {
		if x.isJust() {
			return x
		}
		return y
	}
}

/// The right-biased Maybe Semigroup.
public struct Last<A: Comparable> : Semigroup {
	public typealias M = Maybe<A>

	public init() { }

	public func op(x : M, y : M) -> M {
		if y.isJust() {
			return y
		}
		return x
	}
}
