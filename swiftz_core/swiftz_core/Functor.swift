//
//  Functor.swift
//  swiftz_core
//
//  Created by Josh Abernathy on 6/7/2014.
//  Copyright (c) 2014 Josh Abernathy. All rights reserved.
//

public protocol Functor {
	typealias A
	typealias B
	typealias FB = K1<B>
	func fmap(f: (A -> B)) -> FB
}

// TODO: instance Functor ((->) r)
//class Function1<A, B>: F<A> {
//
//}

// instance Functor Id
public final class Id<A>: K1<A> {
	private let a: () -> A
	public init(_ aa: A) {
		a = { aa }
	}
	public var runId: A {
		return a()
	}
}

extension Id: Functor {
	public typealias B = Any
	public func fmap(f: (A -> B)) -> Id<B> {
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

// instance Functor (Const m)
public final class Const<A, B>: K2<A, B> {
	private let a: () -> A
	public init(_ aa: A) {
		a = { aa }
	}
	public var runConst: A {
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

	public func bimap<B, C, D>(f: (A -> B), g: (C -> D)) -> Const<B, D> {
		return Const<B, D>(f(self.runConst))
	}
}


extension Const: Functor {
	typealias FB = Const<A, B>

	public func fmap<B>(f: (A -> B)) -> Const<A, B> {
		return Const<A, B>(self.runConst)
	}
}
