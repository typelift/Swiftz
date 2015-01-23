//
//  Monoid.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

/// A Monoid is a Semigroup that distinguishes an identity element.
public protocol Monoid : Semigroup {
	/// The identity element of the Monoid.
	func mzero() -> M
}

public func mconcat<M, S: Monoid where S.M == M>(s: S, t: [M]) -> M {
	return (t.reduce(s.mzero()) { s.op($0, y: $1) })
}

/// The Monoid of numeric types under addition.
public struct Sum<A, N: Num where N.N == A> : Monoid {
	public typealias M = A

	let n: () -> N // work around for rdar://17109323

	public init(i : @autoclosure () -> N) {
		n = i
	}

	public func mzero() -> M {
		return n().zero()
	}

	public func op(x : M, y : M) -> M {
		return n().add(x, y: y);
	}
}

/// The Monoid of numeric types under multiplication.
public struct Product<A, N: Num where N.N == A> : Monoid {
	public typealias M = A

	let n: () -> N

	public init(i : @autoclosure () -> N) {
		n = i
	}

	public func mzero() -> M {
		return n().succ(n().zero())
	}

	public func op(x : M, y : M) -> M {
		return n().multiply(x, y: y);
	}
}

