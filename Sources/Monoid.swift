//
//  Monoid.swift
//  Swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014-2016 Maxwell Swadling. All rights reserved.
//

#if !XCODE_BUILD
	import Operadics
	import Swiftx
#endif

/// A `Monoid` is a `Semigroup` that distinguishes an identity element.
public protocol Monoid : Semigroup {
	/// The identity element of the Monoid.
	static var mempty : Self { get }
}

public func mconcat<S : Monoid>(t : [S]) -> S {
	return sconcat(S.mempty, t)
}

extension List : Monoid {
	public static var mempty : List<A> { return [] }
}

extension Array : Monoid {
	public static var mempty : [Element] { return [] }
}

/// The `Monoid` of numeric types under addition.
public struct Sum<N : NumericType> : Monoid {
	public let value : () -> N

	public init(_ x : @autoclosure @escaping () -> N) {
		value = x
	}

	public static var mempty : Sum<N> {
		return Sum(N.zero)
	}

	public func op(_ other : Sum<N>) -> Sum<N> {
		return Sum(self.value().plus(other.value()))
	}
}

/// The `Monoid` of numeric types under multiplication.
public struct Product<N : NumericType> : Monoid {
	public let value : () -> N

	public init(_ x : @autoclosure @escaping () -> N) {
		value = x
	}

	public static var mempty : Product<N> {
		return Product(N.one)
	}

	public func op(_ other : Product<N>) -> Product<N> {
		return Product(self.value().times(other.value()))
	}
}

/// The `Semigroup`-lifting `Optional` `Monoid`
public struct AdjoinNil<A : Semigroup> : Monoid {
	public let value : () -> Optional<A>

	public init(_ x : @autoclosure @escaping () -> Optional<A>) {
		value = x
	}

	public static var mempty : AdjoinNil<A> {
		return AdjoinNil(nil)
	}

	public func op(_ other : AdjoinNil<A>) -> AdjoinNil<A> {
		if let x = self.value() {
			if let y = other.value() {
				return AdjoinNil(x.op(y))
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
	public let value : () -> Optional<A>

	public init(_ x : @autoclosure @escaping () -> Optional<A>) {
		value = x
	}

	public static var mempty : First<A> {
		return First(nil)
	}

	public func op(_ other : First<A>) -> First<A> {
		if self.value() != nil {
			return self
		} else {
			return other
		}
	}
}

/// The right-biased `Maybe` `Monoid`.
public struct Last<A : Comparable> : Monoid {
	public let value : () -> Optional<A>

	public init(_ x : @autoclosure @escaping () -> Optional<A>) {
		value = x
	}

	public static var mempty : Last<A> {
		return Last(nil)
	}

	public func op(_ other : Last<A>) -> Last<A> {
		if other.value() != nil {
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

	public static func left(x: A) -> Dither<A, B> {
		return Dither([Either.Left(x)])
	}

	public static func right(y: B) -> Dither<A, B> {
		return Dither([Either.Right(y)])
	}

	public func fold<C : Monoid>(onLeft f : @escaping (A) -> C, onRight g : @escaping (B) -> C) -> C {
		return values.foldRight(C.mempty) { v, acc in v.either(onLeft: f, onRight: g).op(acc) }
	}

	public static var mempty : Dither<A, B> {
		return Dither([])
	}

	public func op(_ other : Dither<A, B>) -> Dither<A, B> {
		return Dither(values + other.values)
	}

	public init(_ other: Vacillate<A, B>) {
		self.init(other.values)
	}
}
