//
//  Stream.swift
//  Swiftz
//
//  Created by Robert Widmann on 8/19/15.
//  Copyright © 2015 TypeLift. All rights reserved.
//

/// A lazy infinite sequence of values.
///
/// A `Stream` can be thought of as a function indexed by positions - stopping points at which the
/// the function yields a value back.  Rather than hold the entire domain and range of the function
/// in memory, the `Stream` is aware of the current initial point and a way of garnering any
/// subsequent points.
///
/// A Stream is optimized for access to its head, which occurs in O(1).  Element access is O(index)
/// and is made even more expensive by implicit repeated evaluation of complex streams.
///
/// Because `Stream`s and their assorted operations are lazy, building up a `Stream` from a large
/// amount of combinators will necessarily increase the cost of forcing the stream down the line.
/// In addition, due to the fact that a `Stream` is an infinite structure, attempting to traverse
/// the `Stream` in a non-lazy manner will diverge e.g. invoking `.forEach(_:)` or using `zip` with
/// an eager structure and a `Stream`.
public struct Stream<Element> {
	private let step : () -> (head : Element, tail : Stream<Element>)

	private init(_ step : () -> (head : Element, tail : Stream<Element>)) {
		self.step = step
	}

	/// Uses function to construct a `Stream`.
	///
	/// Unlike unfold for lists, unfolds to construct a `Stream` have no base case.
	public static func unfold<A>(initial : A, _ f : A -> (Element, A)) -> Stream<Element> {
		let (x, d) = f(initial)
		return Stream { (x, Stream.unfold(d, f)) }
	}

	/// Repeats a value into a constant stream of that same value.
	public static func `repeat`(x : Element) -> Stream<Element> {
		return Stream { (x, `repeat`(x)) }
	}

	/// Returns a `Stream` of an infinite number of iteratations of applications of a function to a value.
	public static func iterate(initial : Element, _ f : Element -> Element)-> Stream<Element> {
		return Stream { (initial, Stream.iterate(f(initial), f)) }
	}

	/// Cycles a non-empty list into an infinite `Stream` of repeating values.
	///
	/// This function is partial with respect to the empty list.
	public static func cycle(xs : [Element]) -> Stream<Element> {
		switch xs.match {
		case .Nil:
			return error("Cannot cycle an empty list.")
		case .Cons(let x, let xs):
			return Stream { (x, cycle(xs + [x])) }
		}
	}

	public subscript(n : UInt) -> Element {
		return self.index(n)
	}

	/// Looks up the nth element of a `Stream`.
	public func index(n : UInt) -> Element {
		if n == 0 {
			return self.head
		}
		return self.step().tail.index(n.predecessor())
	}

	/// Returns the first element of a `Stream`.
	public var head : Element {
		return self.step().head
	}

	/// Returns the remaining elements of a `Stream`.
	public var tail : Stream<Element> {
		return self.step().tail
	}

	/// Returns a `Stream` of all initial segments of a `Stream`.
	public var inits : Stream<[Element]> {
		return Stream<[Element]> { ([], self.step().tail.inits.fmap({ $0.cons(self.step().head) })) }
	}

	/// Returns a `Stream` of all final segments of a `Stream`.
	public var tails : Stream<Stream<Element>> {
		return Stream<Stream<Element>> { (self, self.step().tail.tails) }
	}

	/// Returns a pair of the first n elements and the remaining eleemnts in a `Stream`.
	public func splitAt(n : UInt) -> ([Element], Stream<Element>) {
		if n == 0 {
			return ([], self)
		}
		let (p, r) = self.tail.splitAt(n - 1)
		return (p.cons(self.head), r)
	}

	/// Returns the longest prefix of values in a `Stream` for which a predicate holds.
	public func takeWhile(p : Element -> Bool) -> [Element] {
		if p(self.step().head) {
			return self.step().tail.takeWhile(p).cons(self.step().head)
		}
		return []
	}

	/// Returns the longest suffix remaining after a predicate holds.
	public func dropWhile(p : Element -> Bool) -> Stream<Element> {
		if p(self.step().head) {
			return self.step().tail.dropWhile(p)
		}
		return self
	}

	/// Returns the first n elements of a `Stream`.
	public func take(n : UInt) -> [Element] {
		if n == 0 {
			return []
		}
		return self.step().tail.take(n - 1).cons(self.step().head)
	}

	/// Returns a `Stream` with the first n elements removed.
	public func drop(n : UInt) -> Stream<Element> {
		if n == 0 {
			return self
		}
		return self.step().tail.tail.drop(n - 1)
	}

	/// Removes elements from the `Stream` that do not satisfy a given predicate.
	///
	/// If there are no elements that satisfy this predicate this function will diverge.
	public func filter(p : Element -> Bool) -> Stream<Element> {
		if p(self.step().head) {
			return Stream { (self.step().head, self.step().tail.filter(p)) }
		}
		return self.step().tail.filter(p)
	}

	/// Returns a `Stream` of alternating elements from each Stream.
	public func interleaveWith(s2 : Stream<Element>) -> Stream<Element> {
		return Stream { (self.step().head, s2.interleaveWith(self.tail)) }
	}

	/// Creates a `Stream` alternating an element in between the values of another Stream.
	public func intersperse(x : Element) -> Stream<Element> {
		return Stream { (self.step().head, Stream { (x, self.step().tail.intersperse(x)) } ) }
	}

	/// Returns a `Stream` of successive reduced values.
	public func scanl<A>(initial : A, combine : A -> Element -> A) -> Stream<A> {
		return Stream<A> { (initial, self.step().tail.scanl(combine(initial)(self.step().head), combine: combine)) }
	}

	/// Returns a `Stream` of successive reduced values.
	public func scanl1(f : Element -> Element -> Element) -> Stream<Element> {
		return self.step().tail.scanl(self.step().head, combine: f)
	}
}

/// Transposes the "Rows and Columns" of an infinite Stream.
public func transpose<T>(ss : Stream<Stream<T>>) -> Stream<Stream<T>> {
	let xs = ss.step().head
	let yss = ss.step().tail
	return Stream { (Stream { (xs.step().head, yss.fmap{ $0.head }) }, transpose(Stream { (xs.step().tail, yss.fmap{ $0.tail }) } )) }
}

/// Zips two `Stream`s into a third Stream using a combining function.
public func zipWith<A, B, C>(s1 : Stream<A>, _ s2 : Stream<B>, _ f : A -> B -> C) -> Stream<C> {
	return Stream { (f(s1.step().head)(s2.step().head), zipWith(s1.step().tail, s2.step().tail, f)) }
}

/// Unzips a `Stream` of pairs into a pair of Streams.
public func unzip<A, B>(sp : Stream<(A, B)>) -> (Stream<A>, Stream<B>) {
	return (sp.fmap(fst), sp.fmap(snd))
}

extension Stream : Functor {
	public typealias A = Element
	public typealias B = Swift.Any
	public typealias FB = Stream<B>

	public func fmap<B>(f : A -> B) -> Stream<B> {
		return Stream<B> { (f(self.step().head), self.step().tail.fmap(f)) }
	}
}

public func <^> <A, B>(f : A -> B, b : Stream<A>) -> Stream<B> {
	return b.fmap(f)
}

extension Stream : Pointed {
	public static func pure(x : A) -> Stream<A> {
		return `repeat`(x)
	}
}

extension Stream : Applicative {
	public typealias FAB = Stream<A -> B>

	public func ap<B>(fab : Stream<A -> B>) -> Stream<B> {
		let f = fab.step().head
		let fs = fab.step().tail
		let x = self.step().head
		let xss = self.step().tail
		return Stream<B> { (f(x), (fs <*> xss)) }
	}
}

public func <*> <A, B>(f : Stream<A -> B> , o : Stream<A>) -> Stream<B> {
	return o.ap(f)
}

extension Stream : ApplicativeOps {
	public typealias C = Any
	public typealias FC = Stream<C>
	public typealias D = Any
	public typealias FD = Stream<D>

	public static func liftA<B>(f : A -> B) -> Stream<A> -> Stream<B> {
		return { a in Stream<A -> B>.pure(f) <*> a }
	}

	public static func liftA2<B, C>(f : A -> B -> C) -> Stream<A> -> Stream<B> -> Stream<C> {
		return { a in { b in f <^> a <*> b  } }
	}

	public static func liftA3<B, C, D>(f : A -> B -> C -> D) -> Stream<A> -> Stream<B> -> Stream<C> -> Stream<D> {
		return { a in { b in { c in f <^> a <*> b <*> c } } }
	}
}

extension Stream : Monad {
	public func bind<B>(f : A -> Stream<B>) -> Stream<B> {
		return Stream<B>.unfold(self.fmap(f)) { ss in
			let bs = ss.step().head
			let bss = ss.step().tail
			return (bs.head, bss.fmap({ $0.tail }))
		}
	}
}

public func >>- <A, B>(x : Stream<A>, f : A -> Stream<B>) -> Stream<B> {
	return x.bind(f)
}

extension Stream : MonadOps {
	public static func liftM<B>(f : A -> B) -> Stream<A> -> Stream<B> {
		return { m1 in m1 >>- { x1 in Stream<B>.pure(f(x1)) } }
	}

	public static func liftM2<B, C>(f : A -> B -> C) -> Stream<A> -> Stream<B> -> Stream<C> {
		return { m1 in { m2 in m1 >>- { x1 in m2 >>- { x2 in Stream<C>.pure(f(x1)(x2)) } } } }
	}

	public static func liftM3<B, C, D>(f : A -> B -> C -> D) -> Stream<A> -> Stream<B> -> Stream<C> -> Stream<D> {
		return { m1 in { m2 in { m3 in m1 >>- { x1 in m2 >>- { x2 in m3 >>- { x3 in Stream<D>.pure(f(x1)(x2)(x3)) } } } } } }
	}
}

public func >>->> <A, B, C>(f : A -> Stream<B>, g : B -> Stream<C>) -> (A -> Stream<C>) {
	return { x in f(x) >>- g }
}

public func <<-<< <A, B, C>(g : B -> Stream<C>, f : A -> Stream<B>) -> (A -> Stream<C>) {
	return f >>->> g
}

extension Stream : Copointed {
	public func extract() -> A {
		return self.head
	}
}

extension Stream : Comonad {
	public typealias FFA = Stream<Stream<A>>

	public func duplicate() -> Stream<Stream<A>> {
		return self.tails
	}

	public func extend<B>(f : Stream<A> -> B) -> Stream<B> {
		return Stream<B> { (f(self), self.tail.extend(f)) }
	}
}

extension Stream : ArrayLiteralConvertible {
	public init(fromArray arr : [Element]) {
		self = Stream.cycle(arr)
	}

	public init(arrayLiteral s : Element...) {
		self.init(fromArray: s)
	}
}

public final class StreamGenerator<Element> : GeneratorType {
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

extension Stream : SequenceType {
	public typealias Generator = StreamGenerator<Element>

	public func generate() -> StreamGenerator<Element> {
		return StreamGenerator(self)
	}
}

extension Stream : CollectionType {
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
