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

/// The Identity Functor holds a singular value.
public struct Id<A> {
	private let a : () -> A

	public init(@autoclosure(escaping) _ aa : () -> A) {
		a = aa
	}

	public var runId : A {
		return a()
	}
}

extension Id : Functor {
	typealias B = Any
	typealias FB = Id<B>

	public func fmap<B>(f : A -> B) -> Id<B> {
		return Id<B>(f(self.runId))
	}
}

extension Id : Copointed {
	public func extract() -> A {
		return self.a()
	}
}

extension Id : Comonad {
	typealias FFA = Id<Id<A>>
	
	public func duplicate() -> Id<Id<A>> {
		return Id<Id<A>>(self)
	}
	
	public func extend<B>(f : Id<A> -> B) -> Id<B> {
		return self.duplicate().fmap(f)
	}
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
	typealias L = V
	typealias R = I
	typealias D = Any

	typealias PAC = Const<L, R>
	typealias PAD = Const<V, D>
	typealias PBC = Const<B, R>
	typealias PBD = Const<B, D>

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
	typealias A = V
	typealias B = Any
	typealias FB = Const<V, I>

	public func fmap<B>(f : V -> B) -> Const<V, I> {
		return Const<V, I>(self.runConst)
	}
}
