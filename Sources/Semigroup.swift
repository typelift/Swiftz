//
//  Semigroup.swift
//  Swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014-2016 Maxwell Swadling. All rights reserved.
//

#if !XCODE_BUILD
	import Operadics
	import Swiftx
#endif

/// A Semigroup is a type with a closed, associative, binary operator.
public protocol Semigroup {

	/// An associative binary operator.
	func op(_ other : Self) -> Self
}

public func <> <A : Semigroup>(lhs : A, rhs : A) -> A {
	return lhs.op(rhs)
}

public func sconcat<S: Semigroup>(_ h : S, _ t : [S]) -> S {
	return t.reduce(h) { $0.op($1) }
}

extension List : Semigroup {
	public func op(_ other : List<A>) -> List<A> {
		return self + other
	}
}

extension NonEmptyList : Semigroup {
	public func op(_ other : NonEmptyList<A>) -> NonEmptyList<A> {
		return NonEmptyList(self.head, self.tail + other.toList())
	}
}

extension Array : Semigroup {
	public func op(_ other : [Element]) -> [Element] {
		return self + other
	}
}

/// The Semigroup of comparable values under MIN().
public struct Min<A: Comparable>: Semigroup {
	public let value : () -> A

	public init(_ x : @autoclosure @escaping () -> A) {
		value = x
	}

	public func op(_ other : Min<A>) -> Min<A> {
		if self.value() < other.value() {
			return self
		} else {
			return other
		}
	}
}

/// The Semigroup of comparable values under MAX().
public struct Max<A: Comparable> : Semigroup {
	public let value : () -> A

	public init(_ x : @autoclosure @escaping () -> A) {
		value = x
	}

	public func op(_ other : Max<A>) -> Max<A> {
		if other.value() < self.value() {
			return self
		} else {
			return other
		}
	}
}

/// The coproduct of `Semigroup`s
public struct Vacillate<A : Semigroup, B : Semigroup> : Semigroup {
	public let values : [Either<A, B>] // this array will never be empty

	public init(_ vs : [Either<A, B>]) {
//		if vs.isEmpty {
//			error("Cannot construct a \(Vacillate<A, B>.self) with no elements.")
//		}
		var vals = [Either<A, B>]()
		for v in vs {
			if let z = vals.last {
				switch (z, v) {
				case let (.Left(x), .Left(y)): vals[vals.endIndex.advanced(by: -1)] = Either.Left(x.op(y))
				case let (.Right(x), .Right(y)): vals[vals.endIndex.advanced(by: -1)] = Either.Right(x.op(y))
				default: vals.append(v)
				}
			} else {
				vals = [v]
			}
		}
		self.values = vals
	}

	public static func left(x: A) -> Vacillate<A, B> {
		return Vacillate([Either.Left(x)])
	}

	public static func right(y: B) -> Vacillate<A, B> {
		return Vacillate([Either.Right(y)])
	}

	public func fold<C : Monoid>(onLeft f : @escaping (A) -> C, onRight g : @escaping (B) -> C) -> C {
		return values.foldRight(C.mempty) { v, acc in v.either(onLeft: f, onRight: g).op(acc) }
	}

	public func op(_ other : Vacillate<A, B>) -> Vacillate<A, B> {
		return Vacillate(values + other.values)
	}
}
