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
public struct NonEmptyList<Element> {
	public let head : Element
	public let tail : List<Element>

	public init(_ a : A, _ t : List<Element>) {
		head = a
		tail = t
	}

	public init(_ a : A, _ t : NonEmptyList<Element>) {
		head = a
		tail = t.toList()
	}

	public init?(_ list : List<Element>) {
		switch list.match {
		case .Nil:
			return nil
		case let .Cons(h, t):
			self.init(h, t)
		}
	}

	public func toList() -> List<Element> {
		return List(head, tail)
	}

	public func reverse() -> NonEmptyList<Element> {
		return NonEmptyList(self.toList().reverse())!
	}

	/// Indexes into a non-empty list.
	public subscript(n : UInt) -> Element {
		if n == 0 {
			return self.head
		}
		return self.tail[n.predecessor()]
	}

	/// Returns the length of the list.
	///
	/// For infinite lists this function will throw an exception.
	public var count : UInt {
		return self.tail.count.successor()
	}
}

public func == <Element : Equatable>(lhs : NonEmptyList<Element>, rhs : NonEmptyList<Element>) -> Bool {
	return lhs.toList() == rhs.toList()
}

public func != <Element : Equatable>(lhs : NonEmptyList<Element>, rhs : NonEmptyList<Element>) -> Bool {
	return lhs.toList() != rhs.toList()
}

extension NonEmptyList : ArrayLiteralConvertible {
	public init(arrayLiteral xs : Element...) {
		var l = NonEmptyList<Element>(xs.first!, List())
		for x in xs[1..<xs.endIndex].reverse() {
			l = NonEmptyList(x, l)
		}
		self = l
	}
}

extension NonEmptyList : SequenceType {
	public typealias Generator = ListGenerator<Element>

	public func generate() -> ListGenerator<Element> {
		return ListGenerator(self.toList())
	}
}

extension NonEmptyList : CollectionType {
	public typealias Index = UInt

	public var startIndex : UInt { return 0 }

	public var endIndex : UInt {
		return self.count
	}
}

extension NonEmptyList : CustomStringConvertible {
	public var description : String {
		let x = self.fmap({ String($0) }).joinWithSeparator(", ")
		return "[\(x)]"
	}
}

extension NonEmptyList : Functor {
	public typealias A = Element
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
	public static func pure(x : A) -> NonEmptyList<Element> {
		return NonEmptyList(x, List())
	}
}

extension NonEmptyList : Applicative {
	public typealias FA = NonEmptyList<Element>
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
	public func extract() -> Element {
		return self.head
	}
}

extension NonEmptyList : Comonad {
	public typealias FFA = NonEmptyList<NonEmptyList<Element>>

	public func duplicate() -> NonEmptyList<NonEmptyList<Element>> {
		switch NonEmptyList(self.tail) {
		case .None:
			return NonEmptyList<NonEmptyList<Element>>(self, List())
		case let .Some(x):
			return NonEmptyList<NonEmptyList<Element>>(self, x.duplicate().toList())
		}
	}

	public func extend<B>(fab : NonEmptyList<Element> -> B) -> NonEmptyList<B> {
		return self.duplicate().fmap(fab)
	}
}
