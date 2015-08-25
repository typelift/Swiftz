//
//  NonEmptyList.swift
//  swiftz
//
//  Created by Maxwell Swadling on 10/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

/// A list that may not ever be empty.
///
/// Traditionally partial operations on regular lists are total with non-empty lists.
public struct NonEmptyList<A> {
	public let head : A
	public let tail : List<A>

	public init(_ a : A, _ t : List<A>) {
		head = a
		tail = t
	}

	public init?(_ list : List<A>) {
		switch list.match {
		case .Nil:
			return nil
		case let .Cons(h, t):
			self.init(h, t)
		}
	}

	public func toList() -> List<A> {
		return List(head, tail)
	}
	
	public func reverse() -> NonEmptyList<A> {
		return NonEmptyList(self.toList().reverse())!
	}
}

public func == <A : Equatable>(lhs : NonEmptyList<A>, rhs : NonEmptyList<A>) -> Bool {
	return lhs.toList() == rhs.toList()
}

public func != <A : Equatable>(lhs : NonEmptyList<A>, rhs : NonEmptyList<A>) -> Bool {
	return lhs.toList() != rhs.toList()
}

extension NonEmptyList : ArrayLiteralConvertible {
	public typealias Element = A

	public init(arrayLiteral s: Element...) {
		var xs : [A] = []
		var g = s.generate()
		let h: A? = g.next()
		while let x : A = g.next() {
			xs.append(x)
		}
		var l = List<A>()
		for x in Array(xs.reverse()) {
			l = List(x, l)
		}
		self = NonEmptyList(h!, l)
	}
}

extension NonEmptyList : SequenceType {
	public typealias Generator = ListGenerator<A>
	
	public func generate() -> ListGenerator<A> {
		return ListGenerator(self.toList())
	}
}

extension NonEmptyList : CustomStringConvertible {
	public var description : String {
		let x = self.fmap({ String($0) }).joinWithSeparator(", ")
		return "[\(x)]"
	}
}

extension NonEmptyList : Functor {
	public typealias B = Any
	public typealias FB = NonEmptyList<B>
	
	public func fmap<B>(f : (A -> B)) -> NonEmptyList<B> {
		return NonEmptyList<B>(f(self.head), self.tail.fmap(f))
	}
}

extension NonEmptyList : Pointed {
	public static func pure(x : A) -> NonEmptyList<A> {
		return NonEmptyList(x, List())
	}
}

extension NonEmptyList : Applicative {
	public typealias FA = NonEmptyList<A>
	public typealias FAB = NonEmptyList<A -> B>

	public func ap<B>(f : NonEmptyList<A -> B>) -> NonEmptyList<B> {
		return f.bind({ f in self.bind({ x in NonEmptyList<B>.pure(f(x)) }) })
	}
}

extension NonEmptyList : Monad {
	public func bind<B>(f : A -> NonEmptyList<B>) -> NonEmptyList<B> {
		let nh = f(self.head)
		return NonEmptyList<B>(nh.head, nh.tail + self.tail.bind { t in f(t).toList() })
	}
}

extension NonEmptyList : Copointed {
	public func extract() -> A {
		return self.head
	}
}

extension NonEmptyList : Comonad {
	public typealias FFA = NonEmptyList<NonEmptyList<A>>

	public func duplicate() -> NonEmptyList<NonEmptyList<A>> {
		switch NonEmptyList(self.tail) {
		case .None:
			return NonEmptyList<NonEmptyList<A>>(self, [])
		case let .Some(x):
			return NonEmptyList<NonEmptyList<A>>(self, x.duplicate().toList())
		}
	}

	public func extend<B>(fab : NonEmptyList<A> -> B) -> NonEmptyList<B> {
		return self.duplicate().fmap(fab)
	}
}
