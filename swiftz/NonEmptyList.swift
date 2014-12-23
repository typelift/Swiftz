//
//  NonEmptyList.swift
//  swiftz
//
//  Created by Maxwell Swadling on 10/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import swiftz_core

public struct NonEmptyList<A> {
	public let head: Box<A>
	public let tail: List<A>
	public init(_ a: A, _ t: List<A>) {
		head = Box(a)
		tail = t
	}
}

public func head<A>() -> Lens<NonEmptyList<A>, NonEmptyList<A>, A, A> {
	return Lens { nel in IxStore(nel.head.value) { NonEmptyList($0, nel.tail) } }
}

public func tail<A>() -> Lens<NonEmptyList<A>, NonEmptyList<A>, List<A>, List<A>> {
	return Lens { nel in IxStore(nel.tail) { NonEmptyList(nel.head.value, $0) } }
}

public func ==<A : Equatable>(lhs : NonEmptyList<A>, rhs : NonEmptyList<A>) -> Bool {
	return (lhs.head.value == rhs.head.value && lhs.tail == rhs.tail)
}

extension NonEmptyList : ArrayLiteralConvertible {
	typealias Element = A

	public init(arrayLiteral s: Element...) {
		var xs : [A] = []
		var g = s.generate()
		let h: A? = g.next()
		while let x : A = g.next() {
			xs.append(x)
		}
		var l = List<A>()
		for x in xs.reverse() {
			l = List(x, l)
		}
		self = NonEmptyList(h!, l)
	}
}

public final class NonEmptyListGenerator<A> : K1<A>, GeneratorType {
	var head: A?
	var l: List<A>?
	public func next() -> A? {
		if let h = head {
			head = nil
			return h
		} else {
			var r = l?.head()
			l = self.l?.tail()
			return r
		}
	}
	public init(_ l : NonEmptyList<A>) {
		head = l.head.value
		self.l = l.tail
	}
}

extension NonEmptyList : SequenceType {
	public func generate() -> NonEmptyListGenerator<A> {
		return NonEmptyListGenerator(self)
	}
}

extension NonEmptyList : Printable {
	public var description : String {
		var x = ", ".join(self.fmap({ "\($0)" }))
		return "[\(x)]"
	}
}

extension NonEmptyList : Functor {
	typealias B = Any
	typealias FB = NonEmptyList<B>
	
	public func fmap<B>(f : (A -> B)) -> NonEmptyList<B> {
		return NonEmptyList<B>(f(self.head.value), self.tail.fmap(f))
	}
}
