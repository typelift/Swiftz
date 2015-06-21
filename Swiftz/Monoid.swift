//
//  Monoid.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

/// A `Monoid` is a `Semigroup` that distinguishes an identity element.
public protocol Monoid : Semigroup {
	/// The identity element of the Monoid.
	static var mzero : Self { get }
}

public func mconcat<S : Monoid>(t : [S]) -> S {
	return sconcat(S.mzero, t: t)
}

extension List : Monoid {
	public static var mzero : List<A> { return [] }
}

extension Array : Monoid {
	public static var mzero : [T] { return [] }
}

/// The `Monoid` of numeric types under addition.
public struct Sum<N : Num> : Monoid {
	public let value : () -> N

	public init(@autoclosure(escaping) _ x : () -> N) {
		value = x
	}

	public static var mzero : Sum<N> {
		return Sum(N.zero)
	}

	public func op(other : Sum<N>) -> Sum<N> {
		return Sum(self.value().plus(other.value()))
	}
}

/// The `Monoid` of numeric types under multiplication.
public struct Product<N : Num> : Monoid {
	public let value : () -> N

	public init(@autoclosure(escaping) _ x : () -> N) {
		value = x
	}

	public static var mzero : Product<N> {
		return Product(N.one)
	}

	public func op(other : Product<N>) -> Product<N> {
		return Product(self.value().times(other.value()))
	}
}

/// The `Semigroup`-lifting `Maybe` `Monoid`
public struct AdjoinNil<A : Semigroup> : Monoid {
	public let value : () -> Maybe<A>

	public init(@autoclosure(escaping) _ x : () -> Maybe<A>) {
		value = x
	}

	public static var mzero : AdjoinNil<A> {
		return AdjoinNil(Maybe.none())
	}

	public func op(other : AdjoinNil<A>) -> AdjoinNil<A> {
		if let x = self.value().value {
			if let y = other.value().value {
				return AdjoinNil(Maybe(x.op(y)))
			} else {
				return self
			}
		} else {
			return other
		}
	}
}

/// The left-biased `Maybe` `Monoid`
public struct First<A : Comparable> : Monoid {
	public let value : () -> Maybe<A>

	public init(@autoclosure(escaping) _ x : () -> Maybe<A>) {
		value = x
	}

	public static var mzero : First<A> {
		return First(Maybe.none())
	}

	public func op(other : First<A>) -> First<A> {
		if self.value().isJust() {
			return self
		} else {
			return other
		}
	}
}

/// The right-biased `Maybe` `Monoid`.
public struct Last<A : Comparable> : Monoid {
	public let value : () -> Maybe<A>

	public init(@autoclosure(escaping) _ x : () -> Maybe<A>) {
		value = x
	}

	public static var mzero : Last<A> {
		return Last(Maybe.none())
	}

	public func op(other : Last<A>) -> Last<A> {
		if other.value().isJust() {
			return other
		} else {
			return self
		}
	}
}

/// The coproduct of `Monoid`s
public struct Dither<A : Monoid, B : Monoid> : Monoid {
	public let values : [Either<A, B>]

	public init(_ vs : [Either<A, B>]) {
		//	if vs.isEmpty { 
		//		error("Cannot construct a \(Vacillate<A, B>.self) with no elements.") 
		//	}
		var vals = [Either<A, B>]()
		for v in vs {
			if let z = vals.last {
				switch (z, v) {
				case let (.Left(x), .Left(y)): vals[vals.endIndex - 1] = Either.Left(x.op(y))
				case let (.Right(x), .Right(y)): vals[vals.endIndex - 1] = Either.Right(x.op(y))
				default: vals.append(v)
				}
			} else {
				vals = [v]
			}
		}
		self.values = vals
	}

	public static func left(x: A) -> Dither<A, B> {
		return Dither([Either.Left(x)])
	}

	public static func right(y: B) -> Dither<A, B> {
		return Dither([Either.Right(y)])
	}

	public func fold<C : Monoid>(onLeft f : A -> C, onRight g : B -> C) -> C {
		return values.foldRight(C.mzero) { v, acc in v.either(onLeft: f, onRight: g).op(acc) }
	}

	public static var mzero : Dither<A, B> {
		return Dither([])
	}

	public func op(other : Dither<A, B>) -> Dither<A, B> {
		return Dither(values + other.values)
	}

	public init(_ other: Vacillate<A, B>) {
		self.init(other.values)
	}
}
