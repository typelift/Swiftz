//
//  Stream.swift
//  Swiftz
//
//  Created by Robert Widmann on 8/19/15.
//  Copyright © 2015-2016 TypeLift. All rights reserved.
//

#if !XCODE_BUILD
	import Operadics
	import Swiftx
#endif

/// A lazy infinite sequence of values.
///
/// A `Stream` can be thought of as a function indexed by positions - stopping 
/// points at which the the function yields a value back.  Rather than hold the 
/// entire domain and range of the function in memory, the `Stream` is aware of 
/// the current initial point and a way of garnering any subsequent points.
///
/// A Stream is optimized for access to its head, which occurs in O(1).  Element
/// access is O(index) and is made even more expensive by implicit repeated 
/// evaluation of complex streams.
///
/// Because `Stream`s and their assorted operations are lazy, building up a 
/// `Stream` from a large amount of combinators will necessarily increase the 
/// cost of forcing the stream down the line. In addition, due to the fact that 
/// a `Stream` is an infinite structure, attempting to traverse the `Stream` in
/// a non-lazy manner will diverge e.g. invoking `.forEach(_:)` or using `zip` 
/// with an eager structure and a `Stream`.
public struct Stream<Element> {
	fileprivate let step : () -> (Element, Stream<Element>)

	fileprivate init(_ step : @escaping () -> (Element, Stream<Element>)) {
		self.step = step
	}

	/// Uses function to construct a `Stream`.
	///
	/// Unlike unfold for lists, unfolds to construct a `Stream` have no base 
	/// case.
	public static func unfold<A>(_ initial : A, _ f : @escaping (A) -> (Element, A)) -> Stream<Element> {
		let (x, d) = f(initial)
		return Stream { (x, Stream.unfold(d, f)) }
	}

	/// Repeats a value into a constant stream of that same value.
	public static func `repeat`(x : Element) -> Stream<Element> {
		return Stream { (x, `repeat`(x: x)) }
	}

	/// Returns a `Stream` of an infinite number of iteratations of applications
	/// of a function to a value.
	public static func iterate(_ initial : Element, _ f : @escaping (Element) -> Element)-> Stream<Element> {
		return Stream { (initial, Stream.iterate(f(initial), f)) }
	}

	/// Cycles a non-empty list into an infinite `Stream` of repeating values.
	///
	/// This function is partial with respect to the empty list.
	public static func cycle(_ xs : [Element]) -> Stream<Element> {
		switch xs.match {
		case .Nil:
			return error("Cannot cycle an empty list.")
		case .Cons(let x, let xs):
			return Stream { (x, cycle(xs + [x])) }
		}
	}

	public subscript(n : UInt) -> Element {
		return self.index(n: n)
	}

	/// Looks up the nth element of a `Stream`.
	public func index(n : UInt) -> Element {
		if n == 0 {
			return self.head
		}
		return self.tail.index(n: n.advanced(by: -1))
	}

	/// Returns the first element of a `Stream`.
	public var head : Element {
		return self.step().0
	}
	
	/// Returns the remaining elements of a `Stream`.
	public var tail : Stream<Element> {
		return self.step().1
	}

	/// Returns a `Stream` of all initial segments of a `Stream`.
	public var inits : Stream<[Element]> {
		return Stream<[Element]> { ([], self.tail.inits.fmap({ $0.cons(self.head) })) }
	}

	/// Returns a `Stream` of all final segments of a `Stream`.
	public var tails : Stream<Stream<Element>> {
		return Stream<Stream<Element>> { (self, self.tail.tails) }
	}
	
	/// Returns a pair of the first n elements and the remaining eleemnts in a 
	/// `Stream`.
	public func splitAt(_ n : UInt) -> ([Element], Stream<Element>) {
		if n == 0 {
			return ([], self)
		}
		let (p, r) = self.tail.splitAt(n - 1)
		return (p.cons(self.head), r)
	}

	/// Returns the longest prefix of values in a `Stream` for which a predicate
	/// holds.
	public func takeWhile(_ p : (Element) -> Bool) -> [Element] {
		if p(self.head) {
			return self.tail.takeWhile(p).cons(self.head)
		}
		return []
	}

	/// Returns the longest suffix remaining after a predicate holds.
	public func dropWhile(_ p : (Element) -> Bool) -> Stream<Element> {
		if p(self.head) {
			return self.tail.dropWhile(p)
		}
		return self
	}

	/// Returns the first n elements of a `Stream`.
	public func take(_ n : UInt) -> [Element] {
		if n == 0 {
			return []
		}
		return self.tail.take(n - 1).cons(self.head)
	}

	/// Returns a `Stream` with the first n elements removed.
	public func drop(_ n : UInt) -> Stream<Element> {
		if n == 0 {
			return self
		}
		return self.tail.drop(n - 1)
	}

	/// Removes elements from the `Stream` that do not satisfy a given predicate.
	///
	/// If there are no elements that satisfy this predicate this function will diverge.
	public func filter(p : @escaping (Element) -> Bool) -> Stream<Element> {
		if p(self.head) {
			return Stream { (self.head, self.tail.filter(p: p)) }
		}
		return self.tail.filter(p: p)
	}

	/// Returns a `Stream` of alternating elements from each Stream.
	public func interleaveWith(s2 : Stream<Element>) -> Stream<Element> {
		return Stream { (self.head, s2.interleaveWith(s2: self.tail)) }
	}

	/// Creates a `Stream` alternating an element in between the values of 
	/// another Stream.
	public func intersperse(x : Element) -> Stream<Element> {
		return Stream { (self.head, Stream { (x, self.tail.intersperse(x: x)) } ) }
	}

	/// Returns a `Stream` of successive reduced values.
	public func scanl<A>(initial : A, combine : @escaping (A) -> (Element) -> A) -> Stream<A> {
		return Stream<A> { (initial, self.tail.scanl(initial: combine(initial)(self.head), combine: combine)) }
	}

	/// Returns a `Stream` of successive reduced values.
	public func scanl1(_ f : @escaping (Element) -> (Element) -> Element) -> Stream<Element> {
		return self.tail.scanl(initial: self.head, combine: f)
	}
}

/// Transposes the "Rows and Columns" of an infinite Stream.
public func transpose<T>(_ ss : Stream<Stream<T>>) -> Stream<Stream<T>> {
	let xs = ss.head
	let yss = ss.tail
	return Stream({ (Stream({ (xs.head, yss.fmap{ $0.head }) }), transpose(Stream({ (xs.tail, yss.fmap{ $0.tail }) }) )) })
}

/// Zips two `Stream`s into a third Stream using a combining function.
public func zipWith<A, B, C>(_ s1 : Stream<A>, _ s2 : Stream<B>, _ f : @escaping (A) -> (B) -> C) -> Stream<C> {
	return Stream({ (f(s1.head)(s2.head), zipWith(s1.tail, s2.tail, f)) })
}

/// Unzips a `Stream` of pairs into a pair of Streams.
public func unzip<A, B>(sp : Stream<(A, B)>) -> (Stream<A>, Stream<B>) {
	return (sp.fmap(fst), sp.fmap(snd))
}

extension Stream /*: Functor*/ {
	public typealias A = Element
	public typealias B = Any
	public typealias FB = Stream<B>

	public func fmap<B>(_ f : @escaping (A) -> B) -> Stream<B> {
		return Stream<B>({ (f(self.head), self.tail.fmap(f)) })
	}
}

public func <^> <A, B>(_ f : @escaping (A) -> B, b : Stream<A>) -> Stream<B> {
	return b.fmap(f)
}

extension Stream /*: Pointed*/ {
	public static func pure(_ x : A) -> Stream<A> {
		return `repeat`(x: x)
	}
}

extension Stream /*: Applicative*/ {
	public typealias FAB = Stream<(A) -> B>

	public func ap<B>(_ fab : Stream<(A) -> B>) -> Stream<B> {
		let f = fab.head
		let fs = fab.tail
		let x = self.head
		let xss = self.tail
		return Stream<B>({ (f(x), (fs <*> xss)) })
	}
}

public func <*> <A, B>(_ f : Stream<(A) -> B> , o : Stream<A>) -> Stream<B> {
	return o.ap(f)
}

extension Stream /*: Cartesian*/ {
	public typealias FTOP = Stream<()>
	public typealias FTAB = Stream<(A, B)>
	public typealias FTABC = Stream<(A, B, C)>
	public typealias FTABCD = Stream<(A, B, C, D)>

	public static var unit : Stream<()> { return Stream<()>.`repeat`(x: ()) }
	public func product<B>(_ r : Stream<B>) -> Stream<(A, B)> {
		return zipWith(self, r, { x in { y in (x, y) } })
	}
	
	public func product<B, C>(_ r : Stream<B>, _ s : Stream<C>) -> Stream<(A, B, C)> {
		return Stream.liftA3({ x in { y in { z in (x, y, z) } } })(self)(r)(s)
	}
	
	public func product<B, C, D>(_ r : Stream<B>, _ s : Stream<C>, _ t : Stream<D>) -> Stream<(A, B, C, D)> {
		return { x in { y in { z in { w in (x, y, z, w) } } } } <^> self <*> r <*> s <*> t
	}
}

extension Stream /*: ApplicativeOps*/ {
	public typealias C = Any
	public typealias FC = Stream<C>
	public typealias D = Any
	public typealias FD = Stream<D>

	public static func liftA<B>(_ f : @escaping (A) -> B) -> (Stream<A>) -> Stream<B> {
		return { (a : Stream<A>) -> Stream<B> in Stream<(A) -> B>.pure(f) <*> a }
	}

	public static func liftA2<B, C>(_ f : @escaping (A) -> (B) -> C) -> (Stream<A>) -> (Stream<B>) -> Stream<C> {
		return { (a : Stream<A>) -> (Stream<B>) -> Stream<C> in { (b : Stream<B>) -> Stream<C> in f <^> a <*> b  } }
	}

	public static func liftA3<B, C, D>(_ f : @escaping (A) -> (B) -> (C) -> D) -> (Stream<A>) -> (Stream<B>) -> (Stream<C>) -> Stream<D> {
		return { (a : Stream<A>) -> (Stream<B>) -> (Stream<C>) -> Stream<D> in { (b : Stream<B>) -> (Stream<C>) -> Stream<D> in { (c : Stream<C>) -> Stream<D> in f <^> a <*> b <*> c } } }
	}
}

extension Stream /*: Monad*/ {
	public func bind<B>(_ f : @escaping (A) -> Stream<B>) -> Stream<B> {
		return Stream<B>.unfold(self.fmap(f)) { ss in
			let bs = ss.head
			let bss = ss.tail
			return (bs.head, bss.fmap({ $0.tail }))
		}
	}
}

public func >>- <A, B>(x : Stream<A>, f : @escaping (A) -> Stream<B>) -> Stream<B> {
	return x.bind(f)
}

extension Stream /*: MonadOps*/ {
	public static func liftM<B>(_ f : @escaping (A) -> B) -> (Stream<A>) -> Stream<B> {
		return { (m1 : Stream<A>) -> Stream<B> in m1 >>- { (x1 : A) in Stream<B>.pure(f(x1)) } }
	}

	public static func liftM2<B, C>(_ f : @escaping (A) -> (B) -> C) -> (Stream<A>) -> (Stream<B>) -> Stream<C> {
		return { (m1 : Stream<A>) -> (Stream<B>) -> Stream<C> in { (m2 : Stream<B>) -> Stream<C> in m1 >>- { (x1 : A) in m2 >>- { (x2 : B) in Stream<C>.pure(f(x1)(x2)) } } } }
	}

	public static func liftM3<B, C, D>(_ f : @escaping (A) -> (B) -> (C) -> D) -> (Stream<A>) -> (Stream<B>) -> (Stream<C>) -> Stream<D> {
		return { (m1 : Stream<A>) -> (Stream<B>) -> (Stream<C>) -> Stream<D> in { (m2 : Stream<B>) -> (Stream<C>) -> Stream<D> in { (m3 : Stream<C>) -> Stream<D> in m1 >>- { (x1 : A) in m2 >>- { (x2 : B) in m3 >>- { (x3 : C) in Stream<D>.pure(f(x1)(x2)(x3)) } } } } } }
	}
}

public func >>->> <A, B, C>(_ f : @escaping (A) -> Stream<B>, g : @escaping (B) -> Stream<C>) -> ((A) -> Stream<C>) {
	return { x in f(x) >>- g }
}

public func <<-<< <A, B, C>(g : @escaping (B) -> Stream<C>, f : @escaping (A) -> Stream<B>) -> ((A) -> Stream<C>) {
	return f >>->> g
}

extension Stream : Copointed {
	public func extract() -> A {
		return self.head
	}
}

extension Stream /*: Comonad*/ {
	public typealias FFA = Stream<Stream<A>>

	public func duplicate() -> Stream<Stream<A>> {
		return self.tails
	}

	public func extend<B>(_ f : @escaping (Stream<A>) -> B) -> Stream<B> {
		return Stream<B>({ (f(self), self.tail.extend(f)) })
	}
}

extension Stream : ExpressibleByArrayLiteral {
	public init(fromArray arr : [Element]) {
		self = Stream.cycle(arr)
	}

	public init(arrayLiteral s : Element...) {
		self.init(fromArray: s)
	}
}

public final class StreamIterator<Element> : IteratorProtocol {
	var l : Stream<Element>

	public func next() -> Optional<Element> {
		let (hd, tl) = l.step()
		l = tl
		return hd
	}

	public init(_ l : Stream<Element>) {
		self.l = l
	}
}

extension Stream : Sequence {
	public typealias Iterator = StreamIterator<Element>

	public func makeIterator() -> StreamIterator<Element> {
		return StreamIterator(self)
	}
}

extension Stream : Collection {
	/// Returns the position immediately after the given index.
	///
	/// - Parameter i: A valid index of the collection. `i` must be less than
	///   `endIndex`.
	/// - Returns: The index value immediately after `i`.
	public func index(after i : UInt) -> UInt {
		return i + 1
	}

	public typealias Index = UInt

	public var startIndex : UInt { return 0 }

	public var endIndex : UInt {
		return error("An infinite list has no end index.")
	}
}

extension Stream : CustomStringConvertible {
	public var description : String {
		return "[\(self.head), ...]"
	}
}

public func sequence<A>(_ ms : [Stream<A>]) -> Stream<[A]> {
	return ms.reduce(Stream<[A]>.pure([]), { n, m in
		return n.bind { xs in
			return m.bind { x in
				return Stream<[A]>.pure(xs + [x])
			}
		}
	})
}
