//
//  Iso.swift
//  swiftz
//
//  Created by Alexander Ronald Altman on 7/22/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//


public struct Iso<S, T, A, B> {
	public let get: S -> A
	public let inject: B -> T

	public init(get: S -> A, inject: B -> T) {
		self.get = get
		self.inject = inject
	}

	public func modify(v: S, _ f: A -> B) -> T {
		return inject(f(get(v)))
	}

	public var asLens: Lens<S, T, A, B> {
		return Lens { s in IxStore(self.get(s)) { self.inject($0) } }
	}

	public var asPrism: Prism<S, T, A, B> {
		return Prism(tryGet: { .Some(self.get($0)) }, inject: inject)
	}
}

public func identity<S, T>() -> Iso<S, T, S, T> {
	return Iso(get: identity, inject: identity)
}

public func •<S, T, I, J, A, B>(i1: Iso<S, T, I, J>, i2: Iso<I, J, A, B>) -> Iso<S, T, A, B> {
	return Iso(get: i2.get • i1.get, inject: i1.inject • i2.inject)
}

public func comp<S, T, I, J, A, B>(i1: Iso<S, T, I, J>)(i2: Iso<I, J, A, B>) -> Iso<S, T, A, B> {
	return i1 • i2
}

// Box iso

public func isoBox<A, B>() -> Iso<Box<A>, Box<B>, A, B> {
	return Iso(get: { $0.value }, inject: { Box($0) } )
}

// Functor base types

public func isoId<A, B>() -> Iso<Id<A>, Id<B>, A, B> {
	return Iso(get: { $0.runId }, inject: { Id($0) })
}

public func isoConst<A, B, X>() -> Iso<Const<A, X>, Const<B, X>, A, B> {
	return Iso(get: { $0.runConst }, inject: { Const($0) })
}
