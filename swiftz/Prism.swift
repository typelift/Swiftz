//
//  Prism.swift
//  swiftz
//
//  Created by Alexander Ronald Altman on 7/22/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//


public struct Prism<S, T, A, B> {
	public let tryGet: S -> A?
	public let inject: B -> T

	public init(tryGet: S -> A?, inject: B -> T) {
		self.tryGet = tryGet
		self.inject = inject
	}

	public func tryModify(s: S, _ f: A -> B) -> T? {
		return { self.inject(f($0)) } <^> tryGet(s)
	}
}

public func •<S, T, I, J, A, B>(p1: Prism<S, T, I, J>, p2: Prism<I, J, A, B>) -> Prism<S, T, A, B> {
	return Prism(tryGet: { p1.tryGet($0) >>- p2.tryGet }, inject: p1.inject • p2.inject)
}

public func comp<S, T, I, J, A, B>(p1: Prism<S, T, I, J>)(p2: Prism<I, J, A, B>) -> Prism<S, T, A, B> {
	return p1 • p2
}
