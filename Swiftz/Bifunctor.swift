//
//  Bifunctor.swift
//  Swiftz
//
//  Created by Robert Widmann on 7/25/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

/// A Functor where the first and second arguments are covariant.
///
/// FIXME: Something in swiftc doesn't like it when conforming instances use a generic <D> in
/// definitions of rightMap.  It has been removed in all instances for now.
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

public struct TupleBF<L, R> : Bifunctor {
	public typealias B = Any
	public typealias D = Any
	public typealias PAC = (L, R)
	public typealias PAD = (L, D)
	public typealias PBC = (B, R)
	public typealias PBD = (B, D)

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

	public func rightMap(g : R -> D) -> (L, D) {
		return self.bimap(identity, g)
	}
}
