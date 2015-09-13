//
//  NonEmptyList.swift
//  Swiftz
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
		let h : A? = g.next()
		while let x : A = g.next() {
			xs.append(x)
		}
		var l = List<A>()
		for x in NonEmptyList(List(fromArray: xs.reverse()))! {
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

public func <^> <A, B>(f : A -> B, l : NonEmptyList<A>) -> NonEmptyList<B> {
	return l.fmap(f)
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

public func <*> <A, B>(f : NonEmptyList<(A -> B)>, l : NonEmptyList<A>) -> NonEmptyList<B> {
	return l.ap(f)
}

extension NonEmptyList : ApplicativeOps {
	public typealias C = Any
	public typealias FC = NonEmptyList<C>
	public typealias D = Any
	public typealias FD = NonEmptyList<D>

	public static func liftA<B>(f : A -> B) -> NonEmptyList<A> -> NonEmptyList<B> {
		return { a in NonEmptyList<A -> B>.pure(f) <*> a }
	}

	public static func liftA2<B, C>(f : A -> B -> C) -> NonEmptyList<A> -> NonEmptyList<B> -> NonEmptyList<C> {
		return { a in { b in f <^> a <*> b  } }
	}

	public static func liftA3<B, C, D>(f : A -> B -> C -> D) -> NonEmptyList<A> -> NonEmptyList<B> -> NonEmptyList<C> -> NonEmptyList<D> {
		return { a in { b in { c in f <^> a <*> b <*> c } } }
	}
}

extension NonEmptyList : Monad {
	public func bind<B>(f : A -> NonEmptyList<B>) -> NonEmptyList<B> {
		let nh = f(self.head)
		return NonEmptyList<B>(nh.head, nh.tail + self.tail.bind { t in f(t).toList() })
	}
}

extension NonEmptyList : MonadOps {
	public static func liftM<B>(f : A -> B) -> NonEmptyList<A> -> NonEmptyList<B> {
		return { m1 in m1 >>- { x1 in NonEmptyList<B>.pure(f(x1)) } }
	}

	public static func liftM2<B, C>(f : A -> B -> C) -> NonEmptyList<A> -> NonEmptyList<B> -> NonEmptyList<C> {
		return { m1 in { m2 in m1 >>- { x1 in m2 >>- { x2 in NonEmptyList<C>.pure(f(x1)(x2)) } } } }
	}

	public static func liftM3<B, C, D>(f : A -> B -> C -> D) -> NonEmptyList<A> -> NonEmptyList<B> -> NonEmptyList<C> -> NonEmptyList<D> {
		return { m1 in { m2 in { m3 in m1 >>- { x1 in m2 >>- { x2 in m3 >>- { x3 in NonEmptyList<D>.pure(f(x1)(x2)(x3)) } } } } } }
	}
}

public func >>->> <A, B, C>(f : A -> NonEmptyList<B>, g : B -> NonEmptyList<C>) -> (A -> NonEmptyList<C>) {
	return { x in f(x) >>- g }
}

public func <<-<< <A, B, C>(g : B -> NonEmptyList<C>, f : A -> NonEmptyList<B>) -> (A -> NonEmptyList<C>) {
	return f >>->> g
}

public func >>- <A, B>(l : NonEmptyList<A>, f : A -> NonEmptyList<B>) -> NonEmptyList<B> {
	return l.bind(f)
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
