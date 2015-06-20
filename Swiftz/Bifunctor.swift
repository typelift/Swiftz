//
//  Bifunctor.swift
//  swiftz
//
//  Created by Robert Widmann on 7/25/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

/// A Functor where the first and second arguments are covariant.
public protocol Bifunctor {
	typealias L
	typealias B
	typealias R
	typealias D
	typealias PAC = K2<L, R>
	typealias PAD = K2<L, D>
	typealias PBC = K2<B, R>
	typealias PBD = K2<B, D>

	/// Map two functions individually over both sides of the bifunctor at the same time.
	func bimap(f : L -> B, _ g : R -> D) -> PBD

	// TODO: File Radar.  Left/Right Map cannot be generalized.

	/// Map over just the first argument of the bifunctor.
	///
	/// Default definition:
	///     bimap(f, identity)
	func leftMap(f : L -> B) -> PBC

	/// Map over just the second argument of the bifunctor.
	///
	/// Default definition:
	///     bimap(identity, g)
	func rightMap(g : R -> D) -> PAD
}

extension Either : Bifunctor {
	typealias B = Any
	typealias D = Any
	typealias PAC = Either<L, R>
	typealias PAD = Either<L, D>
	typealias PBC = Either<B, R>
	typealias PBD = Either<B, D>

	public func bimap<B, D>(f : L -> B, _ g : (R -> D)) -> Either<B, D> {
		switch self {
		case let .Left(bx):
			return Either<B, D>.Left(f(bx))
		case let .Right(bx):
			return Either<B, D>.Right(g(bx))
		}
	}

	public func leftMap<B>(f : L -> B) -> Either<B, R> {
		return self.bimap(f, identity)
	}

	public func rightMap<D>(g : R -> D) -> Either<L, D> {
		return self.bimap(identity, g)
	}
}

public struct TupleBF<L, R> : Bifunctor {
	typealias B = Any
	typealias D = Any
	typealias PAC = (L, R)
	typealias PAD = (L, D)
	typealias PBC = (B, R)
	typealias PBD = (B, D)

	public let t : (L, R)
	
	public init(_ t : (L, R)) {
		self.t = t
	}
	
	public func bimap<B, D>(f : (L -> B), _ g : (R -> D)) -> (B, D) {
		return (f(t.0), g(t.1))
	}

	public func leftMap<B>(f : L -> B) -> (B, R) {
		return self.bimap(f, identity)
	}

	public func rightMap<D>(g : R -> D) -> (L, D) {
		return self.bimap(identity, g)
	}
}
