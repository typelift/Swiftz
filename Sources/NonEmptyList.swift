//
//  NonEmptyList.swift
//  Swiftz
//
//  Created by Maxwell Swadling on 10/06/2014.
//  Copyright (c) 2014-2016 Maxwell Swadling. All rights reserved.
//

#if !XCODE_BUILD
	import Operadics
	import Swiftx
#endif

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
		return self.tail[n.advanced(by: -1)]
	}

	/// Returns the length of the list.
	///
	/// For infinite lists this function will throw an exception.
	public var count : UInt {
		return self.tail.count.advanced(by: 1)
	}
}

public func == <Element : Equatable>(lhs : NonEmptyList<Element>, rhs : NonEmptyList<Element>) -> Bool {
	return lhs.toList() == rhs.toList()
}

public func != <Element : Equatable>(lhs : NonEmptyList<Element>, rhs : NonEmptyList<Element>) -> Bool {
	return lhs.toList() != rhs.toList()
}

extension NonEmptyList : ExpressibleByArrayLiteral {
	public init(arrayLiteral xs : Element...) {
		var l = NonEmptyList<Element>(xs.first!, List())
		for x in xs[1..<xs.endIndex].reversed() {
			l = NonEmptyList(x, l)
		}
		self = l
	}
}

extension NonEmptyList : Sequence {
	public typealias Iterator = ListIterator<Element>

	public func makeIterator() -> ListIterator<Element> {
		return ListIterator(self.toList())
	}
}

extension NonEmptyList : Collection {
	public func index(after i: UInt) -> UInt {
		return i + 1
	}

	public typealias Index = UInt

	public var startIndex : UInt { return 0 }

	public var endIndex : UInt {
		return self.count
	}
}

extension NonEmptyList : CustomStringConvertible {
	public var description : String {
		let x = self.fmap({ String(describing: $0) }).joined(separator: ", ")
		return "[\(x)]"
	}
}

extension NonEmptyList /*: Functor*/ {
	public typealias A = Element
	public typealias B = Any
	public typealias FB = NonEmptyList<B>

	public func fmap<B>(_ f : @escaping (A) -> B) -> NonEmptyList<B> {
		return NonEmptyList<B>(f(self.head), self.tail.fmap(f))
	}
}

public func <^> <A, B>(_ f : @escaping (A) -> B, l : NonEmptyList<A>) -> NonEmptyList<B> {
	return l.fmap(f)
}

extension NonEmptyList /*: Pointed*/ {
	public static func pure(_ x : A) -> NonEmptyList<Element> {
		return NonEmptyList(x, List())
	}
}

extension NonEmptyList /*: Applicative*/ {
	public typealias FA = NonEmptyList<Element>
	public typealias FAB = NonEmptyList<(A) -> B>

	public func ap<B>(_ f : NonEmptyList<(A) -> B>) -> NonEmptyList<B> {
		return f.bind({ f in self.bind({ x in NonEmptyList<B>.pure(f(x)) }) })
	}
}

public func <*> <A, B>(_ f : NonEmptyList<((A) -> B)>, l : NonEmptyList<A>) -> NonEmptyList<B> {
	return l.ap(f)
}

extension NonEmptyList /*: Cartesian*/ {
	public typealias FTOP = NonEmptyList<()>
	public typealias FTAB = NonEmptyList<(A, B)>
	public typealias FTABC = NonEmptyList<(A, B, C)>
	public typealias FTABCD = NonEmptyList<(A, B, C, D)>

	public static var unit : NonEmptyList<()> { return [()] }
	public func product<B>(_ r : NonEmptyList<B>) -> NonEmptyList<(A, B)> {
		return self.mzip(r)
	}
	
	public func product<B, C>(_ r : NonEmptyList<B>, _ s : NonEmptyList<C>) -> NonEmptyList<(A, B, C)> {
		return NonEmptyList<(A, B, C)>(self.toList().product(r.toList(), s.toList()))!
	}
	
	public func product<B, C, D>(_ r : NonEmptyList<B>, _ s : NonEmptyList<C>, _ t : NonEmptyList<D>) -> NonEmptyList<(A, B, C, D)> {
		return NonEmptyList<(A, B, C, D)>(self.toList().product(r.toList(), s.toList(), t.toList()))!
	}
}

extension NonEmptyList /*: ApplicativeOps*/ {
	public typealias C = Any
	public typealias FC = NonEmptyList<C>
	public typealias D = Any
	public typealias FD = NonEmptyList<D>

	public static func liftA<B>(_ f : @escaping (A) -> B) -> (NonEmptyList<A>) -> NonEmptyList<B> {
		return { (a : NonEmptyList<A>) -> NonEmptyList<B> in NonEmptyList<(A) -> B>.pure(f) <*> a }
	}

	public static func liftA2<B, C>(_ f : @escaping (A) -> (B) -> C) -> (NonEmptyList<A>) -> (NonEmptyList<B>) -> NonEmptyList<C> {
		return { (a : NonEmptyList<A>) -> (NonEmptyList<B>) -> NonEmptyList<C> in { (b : NonEmptyList<B>) -> NonEmptyList<C> in f <^> a <*> b  } }
	}

	public static func liftA3<B, C, D>(_ f : @escaping (A) -> (B) -> (C) -> D) -> (NonEmptyList<A>) -> (NonEmptyList<B>) -> (NonEmptyList<C>) -> NonEmptyList<D> {
		return { (a :  NonEmptyList<A>) -> (NonEmptyList<B>) -> (NonEmptyList<C>) -> NonEmptyList<D> in { (b : NonEmptyList<B>) -> (NonEmptyList<C>) -> NonEmptyList<D> in { (c : NonEmptyList<C>) -> NonEmptyList<D> in f <^> a <*> b <*> c } } }
	}
}

extension NonEmptyList /*: Monad*/ {
	public func bind<B>(_ f : @escaping (A) -> NonEmptyList<B>) -> NonEmptyList<B> {
		let nh = f(self.head)
		return NonEmptyList<B>(nh.head, nh.tail + self.tail.bind { t in f(t).toList() })
	}
}

extension NonEmptyList /*: MonadZip*/ {
	public typealias FTABL = NonEmptyList<(A, B)>
	
	public func mzip<B>(_ ma : NonEmptyList<B>) -> NonEmptyList<(A, B)> {
		return NonEmptyList<(A, B)>(self.toList().product(ma.toList()))!
	}
	
	public func mzipWith<B, C>(_ other : NonEmptyList<B>, _ f : @escaping (A) -> (B) -> C) -> NonEmptyList<C> {
		return self.mzip(other).fmap(uncurry(f))
	}
	
	public static func munzip<B>(_ ftab : NonEmptyList<(A, B)>) -> (NonEmptyList<A>, NonEmptyList<B>) {
		return (ftab.fmap(fst), ftab.fmap(snd))
	}
}


extension NonEmptyList /*: MonadOps*/ {
	public static func liftM<B>(_ f : @escaping (A) -> B) -> (NonEmptyList<A>) -> NonEmptyList<B> {
		return { (m1 : NonEmptyList<A>) -> NonEmptyList<B> in m1 >>- { (x1 : A) in NonEmptyList<B>.pure(f(x1)) } }
	}

	public static func liftM2<B, C>(_ f : @escaping (A) -> (B) -> C) -> (NonEmptyList<A>) -> (NonEmptyList<B>) -> NonEmptyList<C> {
		return { (m1 : NonEmptyList<A>) -> (NonEmptyList<B>) -> NonEmptyList<C> in { (m2 : NonEmptyList<B>) -> NonEmptyList<C> in m1 >>- { (x1 : A) in m2 >>- { (x2 : B) in NonEmptyList<C>.pure(f(x1)(x2)) } } } }
	}

	public static func liftM3<B, C, D>(_ f : @escaping (A) -> (B) -> (C) -> D) -> (NonEmptyList<A>) -> (NonEmptyList<B>) -> (NonEmptyList<C>) -> NonEmptyList<D> {
		return { (m1 : NonEmptyList<A>) -> (NonEmptyList<B>) -> (NonEmptyList<C>) -> NonEmptyList<D> in { (m2 : NonEmptyList<B>) -> (NonEmptyList<C>) -> NonEmptyList<D> in { (m3 :  NonEmptyList<C>) -> NonEmptyList<D> in m1 >>- { (x1 : A) in m2 >>- { (x2 : B) in m3 >>- { (x3 : C) in NonEmptyList<D>.pure(f(x1)(x2)(x3)) } } } } } }
	}
}

public func >>->> <A, B, C>(_ f : @escaping (A) -> NonEmptyList<B>, g : @escaping (B) -> NonEmptyList<C>) -> ((A) -> NonEmptyList<C>) {
	return { x in f(x) >>- g }
}

public func <<-<< <A, B, C>(g : @escaping (B) -> NonEmptyList<C>, f : @escaping (A) -> NonEmptyList<B>) -> ((A) -> NonEmptyList<C>) {
	return f >>->> g
}

public func >>- <A, B>(l : NonEmptyList<A>, f : @escaping (A) -> NonEmptyList<B>) -> NonEmptyList<B> {
	return l.bind(f)
}

extension NonEmptyList : Copointed {
	public func extract() -> Element {
		return self.head
	}
}

extension NonEmptyList /*: Comonad*/ {
	public typealias FFA = NonEmptyList<NonEmptyList<Element>>

	public func duplicate() -> NonEmptyList<NonEmptyList<Element>> {
		switch NonEmptyList(self.tail) {
		case .none:
			return NonEmptyList<NonEmptyList<Element>>(self, List())
		case let .some(x):
			return NonEmptyList<NonEmptyList<Element>>(self, x.duplicate().toList())
		}
	}

	public func extend<B>(_ fab : @escaping (NonEmptyList<Element>) -> B) -> NonEmptyList<B> {
		return self.duplicate().fmap(fab)
	}
}
