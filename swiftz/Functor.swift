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

// TODO: instance Functor ((->) r)
//class Function1<A, B>: F<A> {
//
//}

/// The Identity Functor holds a singular value.
public struct Id<A> {
	private let a : @autoclosure () -> A

	public init(_ aa : A) {
		a = aa
	}

	public var runId : A {
		return a()
	}
}

extension Id : Functor {
	public typealias B = Any

	public func fmap<B>(f : A -> B) -> Id<B> {
		return (Id<B>(f(self.runId)))
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
	
	public func extend(f : Id<A> -> B) -> Id<B> {
		return self.duplicate().fmap(f)
	}
}

// The Constant Functor ignores fmap.
public struct Const<A, B> {
	private let a : @autoclosure () -> A

	public init(_ aa : A) {
		a = aa
	}

	public var runConst : A {
		return a()
	}
}

// TODO: File rdar; This has to be in this file or we get linker errors.
extension Const : Bifunctor {
	typealias B = Any
	typealias C = B
	typealias D = Any

	typealias PAC = Const<A, C>
	typealias PAD = Const<A, D>
	typealias PBC = Const<B, C>
	typealias PBD = Const<B, D>

	public func bimap<B, C, D>(f : A -> B, _ g : C -> D) -> Const<B, D> {
		return Const<B, D>(f(self.runConst))
	}

	public func leftMap<C, B>(f : A -> B) -> Const<B, C> {
		return self.bimap(f, identity)
	}

	public func rightMap<C, D>(g : C -> D) -> Const<A, D> {
		return self.bimap(identity, g)
	}
}


extension Const : Functor {
	typealias FB = Const<A, B>

	public func fmap<B>(f : A -> B) -> Const<A, B> {
		return Const<A, B>(self.runConst)
	}
}
