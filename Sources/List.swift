//
//  List.swift
//  Swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014-2016 Maxwell Swadling. All rights reserved.
//

#if !XCODE_BUILD
	import Operadics
	import Swiftx
#endif

/// An enum representing the possible values a list can match against.
public enum ListMatcher<Element> {
	/// The empty list.
	case Nil
	/// A cons cell.
	case Cons(Element, List<Element>)
}

/// A lazy ordered sequence of homogenous values.
///
/// A List is typically constructed by two primitives: Nil and Cons.  Due to 
/// limitations of the language, we instead provide a nullary constructor for 
/// Nil and a Cons Constructor and an actual static function named 
/// `cons(: tail:)` for Cons.  Nonetheless this representation of a list is
/// isomorphic to the traditional inductive definition.  As such, the computed 
/// property `match` is provided that allows the list to be destructured into a
/// more traditional `Nil | Cons(Element, List<Element>)` form that is also 
/// compatible with switch-case blocks.
///
/// This kind of list is optimized for access to its length, which always occurs
/// in O(1), and modifications to its head, which always occur in O(1).  Access 
/// to the elements occurs in O(n).
///
/// Unlike an Array, a List can potentially represent an infinite sequence of 
/// values.  Because the List holds these values in a lazy manner, certain 
/// primitives like iteration or reversing the list will force evaluation of the
/// entire list.  For infinite lists this can lead to a program diverging.
public struct List<Element> {
	let len : Int
	let next : () -> (head : Element, tail : List<Element>)

	/// Constructs a potentially infinite list.
	init(_ next : @autoclosure @escaping () -> (head : Element, tail : List<Element>), isEmpty : Bool = false) {
		self.len = isEmpty ? 0 : -1
		self.next = next
	}

	/// Constructs the empty list.
	///
	/// Attempts to access the head or tail of this list in an unsafe manner 
	/// will throw an exception.
	public init() {
		self.init((error("Attempted to access the head of the empty list."), error("Attempted to access the tail of the empty list.")), isEmpty: true)
	}

	/// Construct a list with a given head and tail.
	public init(_ head : Element, _ tail : List<Element> = List<Element>()) {
		if tail.len == -1 {
			self.len = -1
		} else {
			self.len = tail.len.advanced(by: 1)
		}
		self.next = { (head, tail) }
	}

	/// Appends an element onto the front of a list.
	public static func cons(head : Element, tail : List<Element>) -> List<Element> {
		return List(head, tail)
	}

	/// Destructures a list.  If the list is empty, the result is Nil.  If the 
	/// list contains a value the result is Cons(head, tail).
	public var match : ListMatcher<Element> {
		if self.len == 0 {
			return .Nil
		}
		let (hd, tl) = self.next()
		return .Cons(hd, tl)
	}

	/// Indexes into an array.
	///
	/// Indexing into the empty list will throw an exception.
	public subscript(n : UInt) -> Element {
		switch self.match {
		case .Nil:
			return error("Cannot extract an element from an empty list.")
		case let .Cons(x, _) where n == 0:
			return x
		case let .Cons(_, xs):
			return xs[n.advanced(by: -1)]
		}
	}

	/// Returns the length of the list.
	///
	/// For infinite lists this function will throw an exception.
	public var count : UInt {
		if self.len == -1 {
			return error("Cannot take the length of an infinite list.")
		}
		return UInt(self.len)
	}

	/// Creates a list of n repeating values.
	public static func replicate(_ n : UInt, value : Element) -> List<Element> {
		var l = List<Element>()
		for _ in 0..<n {
			l = List.cons(head: value, tail: l)
		}
		return l
	}

	/// Returns the first element in the list, or None if the list is empty.
	public var head : Optional<Element> {
		switch self.match {
		case .Nil:
			return .none
		case let .Cons(head, _):
			return .some(head)
		}
	}

	/// Returns the tail of the list, or None if the list is empty.
	public var tail : Optional<List<Element>> {
		switch self.match {
		case .Nil:
			return .none
		case let .Cons(_, tail):
			return .some(tail)
		}
	}

	/// Returns an array of all initial segments of the receiver, shortest first
	public var inits : List<List<Element>> {
		return self.reduce(List<List<Element>>()) { xss, x in
			return List<List<Element>>([], xss.map { List(x, $0) })
		}
	}

	/// Returns an array of all final segments of the receiver, longest first
	public var tails : List<List<Element>> {
		return self.reduce(List<List<Element>>()) { x, y in
			return List<List<Element>>.pure(List(y, x.head!)) + x
		}
	}

	/// Returns whether or not the receiver is the empty list.
	public var isEmpty : Bool {
		return self.len == 0
	}

	/// Returns whether or not the receiver has a countable number of elements.
	///
	/// It may be dangerous to attempt to iterate over an infinite list of 
	/// values because the loop will never terminate.
	public var isFinite : Bool {
		return self.len != -1
	}

	/// Yields a new list by applying a function to each element of the receiver.
	public func map<B>(_ f : (A) -> B) -> List<B> {
		switch self.match {
		case .Nil:
			return []
		case let .Cons(hd, tl):
			return List<B>(f(hd), tl.map(f))
		}
	}

	/// Appends two lists together.
	///
	/// If the receiver is infinite, the result of this function will be the 
	/// receiver itself.
	public func append(_ rhs : List<Element>) -> List<Element> {
		switch self.match {
		case .Nil:
			return rhs
		case let .Cons(x, xs):
			return List.cons(head: x, tail: xs.append(rhs))
		}
	}

	/// Maps a function over a list and concatenates the results.
	public func concatMap<B>(_ f : @escaping (Element) -> List<B>) -> List<B> {
		return self.reduce({ l, r in l.append(f(r)) }, initial: List<B>())
	}

	/// Returns a list of elements satisfying a predicate.
	public func filter(_ p : (Element) -> Bool) -> List<Element> {
		switch self.match {
		case .Nil:
			return []
		case let .Cons(x, xs):
			return p(x) ? List(x, xs.filter(p)) : xs.filter(p)
		}
	}

	/// Applies a binary operator to reduce the elements of the receiver to a 
	/// single value.
	public func reduce<B>(_ f : (B) -> (Element) -> B, initial : B) -> B {
		switch self.match {
		case .Nil:
			return initial
		case let .Cons(x, xs):
			return xs.reduce(f, initial: f(initial)(x))
		}
	}

	/// Applies a binary operator to reduce the elements of the receiver to a 
	/// single value.
	public func reduce<B>(_ f : (B, Element) -> B, initial : B) -> B {
		switch self.match {
		case .Nil:
			return initial
		case let .Cons(x, xs):
			return xs.reduce(f, initial: f(initial, x))
		}
	}

	/// Returns a list of successive applications of a function to the elements 
	/// of the receiver.
	///
	/// e.g.
	///
	///     [x0, x1, x2, ...].scanl(f, initial: z) == [z, f(z)(x0), f(f(z)(x0))(x1), f(f(f(z)(x2))(x1))(x0)]
	///       [1, 2, 3, 4, 5].scanl(+, initial: 0) == [0, 1, 3, 6, 10, 15]
	///
	public func scanl<B>(_ f : (B) -> (Element) -> B, initial : B) -> List<B> {
		switch self.match {
		case .Nil:
			return List<B>(initial)
		case let .Cons(x, xs):
			return List<B>.cons(head: initial, tail: xs.scanl(f, initial: f(initial)(x)))
		}
	}

	/// Returns a list of successive applications of a function to the elements 
	/// of the receiver.
	///
	/// e.g.
	///
	///     [x0, x1, x2, ...].scanl(f, initial: z) == [z, f(z, x0), f(f(z, x0), x1), f(f(f(z, x2), x1), x0)]
	///       [1, 2, 3, 4, 5].scanl(+, initial: 0) == [0, 1, 3, 6, 10, 15]
	///
	public func scanl<B>(_ f : (B, Element) -> B, initial : B) -> List<B> {
		switch self.match {
		case .Nil:
			return List<B>(initial)
		case let .Cons(x, xs):
			return List<B>.cons(head: initial, tail: xs.scanl(f, initial: f(initial, x)))
		}
	}

	/// Like scanl but draws its initial value from the first element of the 
	/// receiver itself.
	public func scanl1(_ f : (Element) -> (Element) -> Element) -> List<Element> {
		switch self.match {
		case .Nil:
			return []
		case let .Cons(x, xs):
			return xs.scanl(f, initial: x)
		}
	}

	/// Like scanl but draws its initial value from the first element of the 
	/// receiver itself.
	public func scanl1(_ f : (Element, Element) -> Element) -> List<Element> {
		switch self.match {
		case .Nil:
			return []
		case let .Cons(x, xs):
			return xs.scanl(f, initial: x)
		}
	}

	/// Returns the first n elements of the receiver.
	public func take(_ n : UInt) -> List<Element> {
		if n == 0 {
			return []
		}

		switch self.match {
		case .Nil:
			return []
		case let .Cons(x, xs):
			return List.cons(head: x, tail: xs.take(n.advanced(by: -1)))
		}
	}

	/// Returns the remaining list after dropping n elements from the receiver.
	public func drop(_ n : UInt) -> List<Element> {
		if n == 0 {
			return self
		}

		switch self.match {
		case .Nil:
			return []
		case let .Cons(_, xs):
			return xs.drop(n.advanced(by: -1))
		}
	}

	/// Returns a tuple of the first n elements and the remainder of the list.
	public func splitAt(_ n : UInt) -> (List<Element>, List<Element>) {
		return (self.take(n), self.drop(n))
	}

	/// Takes a separator and a list and intersperses that element throughout 
	/// the list.
	///
	///     ["a","b","c","d","e"].intersperse(",") == ["a",",","b",",","c",",","d",",","e"]
	public func intersperse(_ item : Element) -> List<Element> {
		func prependToAll(sep : Element, l : List<Element>) -> List<Element> {
			switch l.match {
			case .Nil:
				return List()
			case.Cons(let x, let xs):
				return List(sep, List(x, prependToAll(sep: sep, l: xs)))
			}
		}
		switch self.match {
		case .Nil:
			return List()
		case .Cons(let x, let xs):
			return List(x, prependToAll(sep: item, l: xs))
		}
	}

	/// Returns a list of the longest prefix of elements satisfying a predicate.
	public func takeWhile(_ p : (Element) -> Bool) -> List<Element> {
		switch self.match {
		case .Nil:
			return []
		case .Cons(let x, let xs):
			if p(x) {
				return List.cons(head: x, tail: xs.takeWhile(p))
			}
			return []
		}
	}

	/// Returns a list of the remaining elements after the longest prefix of 
	/// elements satisfying a predicate has been removed.
	public func dropWhile(_ p : (Element) -> Bool) -> List<Element> {
		switch self.match {
		case .Nil:
			return []
		case let .Cons(x, xs):
			if p(x) {
				return xs.dropWhile(p)
			}
			return self
		}
	}

	/// Takes a list and groups its arguments into sublists of duplicate 
	/// elements found next to each other according to an equality predicate.
	public func groupBy(_ p : (Element) -> (Element) -> Bool) -> List<List<Element>> {
		switch self.match {
		case .Nil:
			return []
		case .Cons(let x, let xs):
			let (ys, zs) = xs.span(p(x))
			let l = List(x, ys)
			return List<List<Element>>(l, zs.groupBy(p))
		}
	}

	/// Takes a list and groups its arguments into sublists of duplicate 
	/// elements found next to each other according to an equality predicate.
	public func groupBy(_ p : @escaping (Element, Element) -> Bool) -> List<List<Element>> {
		return self.groupBy(curry(p))
	}

	/// Returns a tuple where the first element is the longest prefix of 
	/// elements that satisfy a given predicate and the second element is the 
	/// remainder of the list:
	///
	///     [1, 2, 3, 4, 1, 2, 3, 4].span(<3) == ([1, 2],[3, 4, 1, 2, 3, 4])
	///     [1, 2, 3].span(<9)                == ([1, 2, 3],[])
	///     [1, 2, 3].span(<0)                == ([],[1, 2, 3])
	///
	///     span(list, p) == (takeWhile(list, p), dropWhile(list, p))
	public func span(_ p : (Element) -> Bool) -> (List<Element>, List<Element>) {
		switch self.match {
		case .Nil:
			return ([], [])
		case .Cons(let x, let xs):
			if p(x) {
				let (ys, zs) = xs.span(p)
				return (List(x, ys), zs)
			}
			return ([], self)
		}
	}

	/// Returns a tuple where the first element is the longest prefix of 
	/// elements that do not satisfy a given predicate and the second element is
	/// the remainder of the list:
	///
	/// `extreme(_:)` is the dual to span(_:)` and satisfies the law
	///
	///     self.extreme(p) == self.span((!) • p)
	public func extreme(_ p : @escaping (Element) -> Bool) -> (List<Element>, List<Element>) {
		return self.span { ((!) • p)($0) }
	}

	/// Returns the elements of the receiver in reverse order.
	///
	/// For infinite lists this function will diverge.
	public func reverse() -> List<Element> {
		return self.reduce(flip(curry(List.cons)), initial: [])
	}

	/// Given a predicate, searches the list until it find the first match, and
	/// returns that, or None if no match was found.
	///
	/// For infinite lists this function will diverge.
	public func find(_ pred: (Element) -> Bool) -> Optional<Element> {
		for x in self {
			if pred(x) {
				return x
			}
		}
		return nil
	}

	/// For an associated list, such as [(1,"one"),(2,"two")], takes a function 
	/// (pass the identity function) and a key and returns the value for the 
	/// given key, if there is one, or None otherwise.
	public func lookup<K : Equatable, V>(_ ev : @escaping (Element) -> (K, V), key : K) -> Optional<V> {
		return (snd • ev) <^> self.find({ ev($0).0 == key })
	}

	/// Returns a List of an infinite number of iteratations of applications of 
	/// a function to an initial value.
	public static func iterate(_ f : @escaping (Element) -> Element, initial : Element) -> List<Element> {
		return List((initial, self.iterate(f, initial: f(initial))))
	}

	/// Cycles a finite list into an infinite list.
	public func cycle() -> List<Element> {
		let (hd, tl) = self.next()
		return List((hd, (tl + [hd]).cycle()))
	}
}

// File radar: If these lines are uncommented the compiler throws spurious "Redundant Conformance to
// Foo errors in the rest of the file.
//
//extension List where Element : Equatable {
//	/// Takes two lists and returns true if the first string is a prefix of the second string.
//	public func isPrefixOf(r : List<Element>) -> Bool {
//		switch (self.match, r.match) {
//		case (.Cons(let x, let xs), .Cons(let y, let ys)) where (x == y):
//			return xs.isPrefixOf(ys)
//		case (.Nil, _):
//			return true
//		default:
//			return false
//		}
//	}
//
//	/// Takes two lists and returns true if the first string is a suffix of the second string.
//	public func isSuffixOf(r : List<Element>) -> Bool {
//		return self.reverse().isPrefixOf(r.reverse())
//	}
//
//	/// Takes two lists and returns true if the first string is contained entirely anywhere in the
//	/// second string.
//	public func isInfixOf(r : List<Element>) -> Bool {
//		return r.tails.any(self.isPrefixOf)
//	}
//
//	/// Takes two strings and drops items in the first from the second.  If the first string is not a
//	/// prefix of the second string this function returns Nothing.
//	public func stripPrefix(r : List<Element>) -> Optional<List<Element>> {
//		switch (self.match, r.match) {
//		case (.Nil, _):
//			return .some(r)
//		case (.Cons(let x, let xs), .Cons(let y, _)) where x == y:
//			return xs.stripPrefix(xs)
//		default:
//			return .none
//		}
//	}
//
//	/// Takes two strings and drops items in the first from the end of the second.  If the first
//	/// string is not a suffix of the second string this function returns nothing.
//	public func stripSuffix(r : List<Element>) -> Optional<List<Element>> {
//		return self.reverse().stripPrefix(r.reverse()).map({ $0.reverse() })
//	}
//
//	/// Takes a list and groups its arguments into sublists of duplicate elements found next to each
//	/// other.
//	///
//	///     group([0, 1, 1, 2, 3, 3, 4, 5, 6, 7, 7]) == [[0], [1, 1], [2], [3, 3], [4], [5], [6], [7, 7]]
//	public var group : List<List<Element>> {
//		return self.groupBy { a in { b in a == b } }
//	}
//}

/// Flattens a list of lists into a single lists.
public func concat<A>(_ xss : List<List<A>>) -> List<A> {
	return xss.reduce(+, initial: [])
}

/// Appends two lists together.
public func + <A>(lhs : List<A>, rhs : List<A>) -> List<A> {
	return lhs.append(rhs)
}

/// MARK: Equatable

public func == <A : Equatable>(lhs : List<A>, rhs : List<A>) -> Bool {
	if !lhs.isFinite || !rhs.isFinite {
		return error("Fatal: One of the lists being compared for equality is not finite.")
	}

	if lhs.count != rhs.count {
		return false
	}

	return zip(lhs, rhs).map(==).reduce(true) { $0 && $1 }
}

public func != <A : Equatable>(lhs : List<A>, rhs : List<A>) -> Bool {
	return !(lhs == rhs)
}

/// MARK: Collection Protocols

extension List : ExpressibleByArrayLiteral {
	public init(fromArray arr : [Element]) {
		var xs : [A] = []
		var g = arr.makeIterator()
		while let x : A = g.next() {
			xs.append(x)
		}

		var l = List()
		for x in xs.reversed() {
			l = List(x, l)
		}
		self = l
	}

	public init(arrayLiteral s : Element...) {
		self.init(fromArray: s)
	}
}

public final class ListIterator<Element> : IteratorProtocol {
	var l : List<Element>

	public func next() -> Optional<Element> {
		if l.len == 0 {
			return nil
		}

		let (hd, tl) = l.next()
		l = tl
		return hd
	}

	public init(_ l : List<Element>) {
		self.l = l
	}
}

extension List : Sequence {
	public typealias Iterator = ListIterator<Element>

	public func makeIterator() -> ListIterator<Element> {
		return ListIterator(self)
	}
}

extension List : Collection {
    public func index(after i: UInt) -> UInt {
        return i + 1
    }

	public typealias Index = UInt

	public var startIndex : UInt { return 0 }

	public var endIndex : UInt {
		return self.isFinite ? self.count : error("An infinite list has no end index.")
	}
}

extension List : CustomStringConvertible {
	public var description : String {
		if self.isFinite {
			return self.map({ String(describing: $0) }).intersperse(", ").reduce("", +)
		}
		return "[...]"
	}
}

/// MARK: Control.*

extension List /*: Functor*/ {
	public typealias B = Any
	public typealias FB = List<B>

	public func fmap<B>(_ f : @escaping (A) -> B) -> List<B> {
		return self.map(f)
	}
}

public func <^> <A, B>(_ f : @escaping (A) -> B, l : List<A>) -> List<B> {
	return l.fmap(f)
}

extension List /*: Pointed*/ {
	public typealias A = Element
	public static func pure(_ a : A) -> List<Element> {
		return List(a, [])
	}
}

extension List /*: ApplicativeOps*/ {
	public typealias C = Any
	public typealias FC = List<C>
	public typealias D = Any
	public typealias FD = List<D>

	public static func liftA<B>(_ f : @escaping (A) -> B) -> (List<A>) -> List<B> {
		return { (a : List<A>) -> List<B> in List<(A) -> B>.pure(f) <*> a }
	}

	public static func liftA2<B, C>(_ f : @escaping (A) -> (B) -> C) -> (List<A>) -> (List<B>) -> List<C> {
		return { (a : List<A>) -> (List<B>) -> List<C> in { (b : List<B>) -> List<C> in f <^> a <*> b  } }
	}

	public static func liftA3<B, C, D>(_ f : @escaping (A) -> (B) -> (C) -> D) -> (List<A>) -> (List<B>) -> (List<C>) -> List<D> {
		return { (a : List<A>) -> (List<B>) -> (List<C>) -> List<D> in { (b : List<B>) -> (List<C>) -> List<D> in { (c : List<C>) -> List<D> in f <^> a <*> b <*> c } } }
	}
}

extension List /*: Applicative*/ {
	public typealias FA = List<Element>
	public typealias FAB = List<(A) -> B>

	public func ap<B>(_ f : List<(A) -> B>) -> List<B> {
		return concat(f.map(self.map))
	}
}

public func <*> <A, B>(_ f : List<((A) -> B)>, l : List<A>) -> List<B> {
	return l.ap(f)
}

extension List /*: Cartesian*/ {
	public typealias FTOP = List<()>
	public typealias FTAB = List<(A, B)>
	public typealias FTABC = List<(A, B, C)>
	public typealias FTABCD = List<(A, B, C, D)>

	public static var unit : List<()> { return [()] }
	public func product<B>(_ r : List<B>) -> List<(A, B)> {
		return self.mzip(r)
	}
	
	public func product<B, C>(_ r : List<B>, _ s : List<C>) -> List<(A, B, C)> {
		return List.liftA3({ x in { y in { z in (x, y, z) } } })(self)(r)(s)
	}
	
	public func product<B, C, D>(_ r : List<B>, _ s : List<C>, _ t : List<D>) -> List<(A, B, C, D)> {
		return { x in { y in { z in { w in (x, y, z, w) } } } } <^> self <*> r <*> s <*> t
	}
}

extension List /*: Monad*/ {
	public func bind<B>(_ f : @escaping (A) -> List<B>) -> List<B> {
		return self.concatMap(f)
	}
}

public func >>- <A, B>(l : List<A>, f : @escaping (A) -> List<B>) -> List<B> {
	return l.bind(f)
}

extension List /*: MonadOps*/ {
	public static func liftM<B>(_ f : @escaping (A) -> B) -> (List<A>) -> List<B> {
		return { (m1 : List<A>) -> List<B> in m1 >>- { (x1 : A) in List<B>.pure(f(x1)) } }
	}

	public static func liftM2<B, C>(_ f : @escaping (A) -> (B) -> C) -> (List<A>) -> (List<B>) -> List<C> {
		return { (m1 : List<A>) -> (List<B>) -> List<C> in { (m2 : List<B>) -> List<C> in m1 >>- { (x1 : A) in m2 >>- { (x2 : B) in List<C>.pure(f(x1)(x2)) } } } }
	}

	public static func liftM3<B, C, D>(_ f : @escaping (A) -> (B) -> (C) -> D) -> (List<A>) -> (List<B>) -> (List<C>) -> List<D> {
		return { (m1 : List<A>) -> (List<B>) -> (List<C>) -> List<D> in { (m2 : List<B>) -> (List<C>) -> List<D> in { (m3 : List<C>) -> List<D> in m1 >>- { (x1 : A) in m2 >>- { (x2 : B) in m3 >>- { (x3 : C) in List<D>.pure(f(x1)(x2)(x3)) } } } } } }
	}
}

public func >>->> <A, B, C>(_ f : @escaping (A) -> List<B>, g : @escaping (B) -> List<C>) -> ((A) -> List<C>) {
	return { x in f(x) >>- g }
}

public func <<-<< <A, B, C>(g : @escaping (B) -> List<C>, f : @escaping (A) -> List<B>) -> ((A) -> List<C>) {
	return f >>->> g
}

extension List /*: MonadPlus*/ {
	public static var mzero : List<A> {
		return []
	}

	public func mplus(_ other : List<A>) -> List<A> {
		return self + other
	}
}

public func sequence<A>(_ ms: [List<A>]) -> List<[A]> {
	return ms.reduce(List<[A]>.pure([])) { n, m in
		return n.bind { xs in
			return m.bind { x in
				return List<[A]>.pure(xs + [x])
			}
		}
	}
}

extension List /*: MonadZip*/ {
	public typealias FTABL = List<(A, B)>
	
	public func mzip<B>(_ ma : List<B>) -> List<(A, B)> {
		return List<(A, B)>(fromArray: zip(self, ma).map(identity))
	}
	
	public func mzipWith<B, C>(_ other : List<B>, _ f : @escaping (A) -> (B) -> C) -> List<C> {
		return self.mzip(other).map(uncurry(f))
	}
	
	public static func munzip<B>(_ ftab : List<(A, B)>) -> (List<A>, List<B>) {
		return (ftab.map(fst), ftab.map(snd))
	}
}
