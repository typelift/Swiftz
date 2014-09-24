//
//  Functor.swift
//  swiftz
//
//  Created by Robert Widmann on 9/23/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Basis

public final class Id<A> : K1<A> {
	let a : () -> A

	public init(_ aa: A) {
		a = { aa }
	}
	public var runId: A {
		return a()
	}
}

extension Id : Functor {
	typealias B = Any
	typealias FA = Id<A>
	typealias FB = Id<B>

	public class func fmap<B>(f: (A -> B)) -> Id<A> -> Id<B> {
		return { id in (Id<B>(f(id.runId))) }
	}
}

public func <%><A, B>(f: A -> B, id : Id<A>) -> Id<B> {
	return Id.fmap(f)(id)
}

public func <% <A, B>(x : A, id : Id<B>) -> Id<A> {
	return Id.fmap(const(x))(id)
}

// instance Functor (Const m)
public class Const<T, U> : K2<T, U> {
	let a : () -> U

	public init(_ aa: U) {
		a = { aa }
	}
	public var runConst: U {
		return a()
	}
}

extension Const : Functor {
	typealias A = U
	typealias B = Any
	typealias FA = Const<T, U>
	typealias FB = Const<T, U>

	public class func fmap<B>(_ : (U -> B)) -> Const<T, U> -> Const<T, U> {
		return { c in (Const(c.runConst)) }
	}
}

public func <%><T, A, B>(f: A -> B, id : Const<T, A>) -> Const<T, A> {
	return Const.fmap(f)(id)
}

public func <% <T, A>(x : A, id : Const<T, A>) -> Const<T, A> {
	return Const.fmap(const(x))(id)
}
