//
//  Bifunctor.swift
//  swiftz
//
//  Created by Robert Widmann on 7/25/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

/// A Functor where the first and second arguments are covariant.
public protocol Bifunctor {
	typealias A
	typealias B
	typealias C
	typealias D
	typealias PAC = K2<A, C>
	typealias PAD = K2<A, D>
	typealias PBC = K2<B, C>
	typealias PBD = K2<B, D>

	/// Map two functions individually over both sides of the bifunctor at the same time.
	func bimap(f : A -> B, _ g : C -> D) -> PBD

	// TODO: File Radar.  Left/Right Map cannot be generalized.

	/// Map over just the first argument of the bifunctor.
	///
	/// Default definition:
	///     bimap(f, identity)
	func leftMap(f : A -> B) -> PBC

	/// Map over just the second argument of the bifunctor.
	///
	/// Default definition:
	///     bimap(identity, g)
	func rightMap(g : C -> D) -> PAD
}

public struct EitherBF<A, C> : Bifunctor {
	typealias B = Any
	typealias D = Any

	public let e: Either<A, C>

	public init(_ e: Either<A, C>) {
		self.e = e
	}

	public func bimap<B, D>(f: (A -> B), _ g: (C -> D)) -> Either<B, D> {
		switch e {
		case .Left(let bx):
			return Either.Left(Box<B>(f(bx.value)))
		case .Right(let bx):
			return Either.Right(Box<D>(g(bx.value)))
		}
	}

	public func leftMap<B>(f : A -> B) -> Either<B, C> {
		return self.bimap(f, identity)
	}

	public func rightMap<D>(g : C -> D) -> Either<A, D> {
		return self.bimap(identity, g)
	}
}

// TODO: File rdar; This has to be in Either.swift or we get linker errors.
//extension Either : Bifunctor {
//	typealias A = L
//	typealias B = Any
//	typealias C = R
//	typealias D = Any
//	typealias PAC = Either<A, C>
//	typealias PAD = Either<A, D>
//	typealias PBC = Either<B, C>
//	typealias PBD = Either<B, D>
//
//	public func bimap<B, D>(f : A -> B, _ g : (C -> D)) -> Either<B, D> {
//		switch self {
//		case .Left(let bx): 
//			return Either<B, D>.Left(Box(f(bx.value)))
//		case .Right(let bx): 
//			return Either<B, D>.Right(Box(g(bx.value)))
//		}
//	}
//
//	public func leftMap<B>(f : A -> B) -> Either<B, C> {
//		return self.bimap(f, identity)
//	}
//
//	public func rightMap<D>(g : C -> D) -> Either<A, D> {
//		return self.bimap(identity, g)
//	}
//}

public struct TupleBF<A, C>: Bifunctor {
	typealias B = Any
	typealias D = Any

	public let t : (A, C)
	
	public init(_ t : (A, C)) {
		self.t = t
	}
	
	public func bimap<B, D>(f : (A -> B), _ g : (C -> D)) -> (B, D) {
		return (f(t.0), g(t.1))
	}

	public func leftMap<B>(f : A -> B) -> (B, C) {
		return self.bimap(f, identity)
	}

	public func rightMap<D>(g : C -> D) -> (A, D) {
		return self.bimap(identity, g)
	}
}
