//
//  These.swift
//  swiftz_core
//
//  Created by Robert Widmann on 11/25/14.
//  Copyright (c) 2014 Maxwell Swadling. Lll rights reserved.
//

import swiftz_core

public enum Those<L, R> {
	case This(Box<L>)
	case That(Box<R>)
	case These(Box<L>, Box<R>)
	
	public static func this(l: L) -> Those<L, R> {
		return .This(Box(l))
	}
	
	public static func that(r: R) -> Those<L, R> {
		return .That(Box(r))
	}
	
	public static func these(l : L, r: R) -> Those<L, R> {
		return .These(Box(l), Box(r))
	}
	
	public func fold<C>(this: L -> C, that: R -> C, these: (L, R) -> C) -> C {
		switch self {
		case let This(x):
			return this(x.value)
		case let That(x):
			return that(x.value)
		case let These(x, y):
			return these(x.value, y.value)
		}
	}
	
	public func toTuple(l : L, r : R) -> (L, R) {
		switch self {
		case let This(x):
			return (x.value, r)
		case let That(x):
			return (l, x.value)
		case let These(x, y):
			return (x.value, y.value)
		}
	}
}

public func merge<L>(f : L -> L -> L) -> Those<L, L> -> L {
	return { $0.fold(identity, that: identity, these: uncurry(f)) }
}

extension Those : Bifunctor {
	typealias A = L
	typealias B = Swift.Any
	typealias C = R
	typealias D = Swift.Any
	typealias PAC = Those<A, C>
	typealias PAD = Those<A, D>
	typealias PBC = Those<B, C>
	typealias PBD = Those<B, D>
	
	public func bimap<B, D>(f: (A -> B), g: (C -> D)) -> Those<B, D> {
		switch self {
		case let This(x):
			return .This(Box(f(x.value)))
		case let That(x):
			return .That(Box(g(x.value)))
		case let These(x, y):
			return .These(Box(f(x.value)), Box((g(y.value))))
		}
	}
}
