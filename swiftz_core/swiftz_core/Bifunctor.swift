//
//  Bifunctor.swift
//  swiftz
//
//  Created by Robert Widmann on 7/25/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

public protocol Bifunctor {
	typealias A
	typealias B
	typealias C
	typealias D
	typealias PAC = K2<A, C>
	typealias PAD = K2<A, D>
	typealias PBC = K2<B, C>
	typealias PBD = K2<B, D>

	func bimap(f: (A -> B), g: (C -> D)) -> PBD
}

// TODO: Collapse Bifunctor instances so [left/right]Map typecheck
//public func leftMap<B : Bifunctor>(x: B, f : (B.A -> B.B)) -> B.PBC {
//  return x.bimap(f, g: identity)
//}
//
//public func rightMap<B : Bifunctor, C, D>(x: B, g : (B.C -> B.D)) -> B.PAD {
//  return x.bimap(identity, g: g)
//}

public struct EitherBF<A, B, C, D>: Bifunctor {
	public let e: Either<A, C>

	public init(_ e: Either<A, C>) {
		self.e = e
	}

	public func bimap(f: (A -> B), g: (C -> D)) -> Either<B, D> {
		switch e {
		case .Left(let bx): return Either.Left(Box<B>(f(bx.value)))
		case .Right(let bx): return Either.Right(Box<D>(g(bx.value)))
		}
	}
}

public struct TupleBF<A, B, C, D>: Bifunctor {
	public let t: (A, C)

	public init(_ t: (A, C)) {
		self.t = t
	}

	public func bimap(f: (A -> B), g: (C -> D)) -> (B, D) {
		return (f(t.0), g(t.1))
	}
}
