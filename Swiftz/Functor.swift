//
//  Functor.swift
//  swiftz_core
//
//  Created by Josh Abernathy on 6/7/2014.
//  Copyright (c) 2014 Josh Abernathy. All rights reserved.
//

/// Functors are mappings from the functions and objects in one set to the functions and objects
/// in another set.
public protocol Functor {
	/// Source
	typealias A
	/// Target
	typealias B
	/// A Target Functor
	typealias FB = K1<B>

	/// Map a function over the value encapsulated by the Functor.
	func fmap(f : A -> B) -> FB
}


// The Constant Functor ignores fmap.
public struct Const<V, I> {
	private let a :  () -> V

	public init(@autoclosure(escaping) _ aa : () -> V) {
		a = aa
	}

	public var runConst : V {
		return a()
	}
}

extension Const : Bifunctor {
	public typealias L = V
	public typealias R = I
	public typealias D = Any

	public typealias PAC = Const<L, R>
	public typealias PAD = Const<V, D>
	public typealias PBC = Const<B, R>
	public typealias PBD = Const<B, D>

	public func bimap<B, D>(f : V -> B, _ : I -> D) -> Const<B, D> {
		return Const<B, D>(f(self.runConst))
	}

	public func leftMap<B>(f : V -> B) -> Const<B, I> {
		return self.bimap(f, identity)
	}

	public func rightMap<D>(g : I -> D) -> Const<V, D> {
		return self.bimap(identity, g)
	}
}

extension Const : Functor {
	public typealias A = V
	public typealias B = Any
	public typealias FB = Const<V, I>

	public func fmap<B>(f : V -> B) -> Const<V, I> {
		return Const<V, I>(self.runConst)
	}
}
