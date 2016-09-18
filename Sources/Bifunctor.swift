//
//  Bifunctor.swift
//  Swiftz
//
//  Created by Robert Widmann on 7/25/14.
//  Copyright (c) 2014-2016 Maxwell Swadling. All rights reserved.
//

#if !XCODE_BUILD
	import Swiftx
#endif

/// A Functor where the first and second arguments are covariant.
///
/// FIXME: Something in swiftc doesn't like it when conforming instances use a 
/// generic <D> in definitions of rightMap.  It has been removed in all 
/// instances for now.
public protocol Bifunctor {
	associatedtype L
	associatedtype B
	associatedtype R
	associatedtype D
	associatedtype PAC = K2<L, R>
	associatedtype PAD = K2<L, D>
	associatedtype PBC = K2<B, R>
	associatedtype PBD = K2<B, D>

	/// Map two functions individually over both sides of the bifunctor at the 
	/// same time.
	func bimap(_ f : (L) -> B, _ g : (R) -> D) -> PBD

	// TODO: File Radar.  Left/Right Map cannot be generalized.

	/// Map over just the first argument of the bifunctor.
	///
	/// Default definition:
	///     bimap(f, identity)
	func leftMap(_ f : (L) -> B) -> PBC

	/// Map over just the second argument of the bifunctor.
	///
	/// Default definition:
	///     bimap(identity, g)
	func rightMap(_ g : (R) -> D) -> PAD
}

public struct TupleBF<L, R> /*: Bifunctor*/ {
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

	public func bimap<B, D>(_ f : ((L) -> B), _ g : ((R) -> D)) -> (B, D) {
		return (f(t.0), g(t.1))
	}

	public func leftMap<B>(_ f : @escaping (L) -> B) -> (B, R) {
		return self.bimap(f, identity)
	}

	public func rightMap(g : @escaping (R) -> D) -> (L, D) {
		return self.bimap(identity, g)
	}
}
