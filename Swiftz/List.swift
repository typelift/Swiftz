//
//  List.swift
//  swiftz_core
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

/// An enum representing the possible values a list can match against.
public enum ListMatcher<A> {
	/// The empty list.
	case Nil
	/// A cons cell.
	case Cons(A, List<A>)
}

/// A lazy ordered sequence of homogenous values.
///
/// A List is typically constructed by two primitives: Nil and Cons.  Due to limitations of the
/// language, we instead provide a nullary constructor for Nil and a Cons Constructor and an actual
/// static function named `cons(: tail:)` for Cons.  Nonetheless this representation of a list is
/// isomorphic to the traditional inductive definition.  As such, the method `match()` is provided
/// that allows the list to be destructured into a more traditional `Nil | Cons(A, List<A>)` form
/// that is also compatible with switch-case blocks.
///
/// This kind of list is optimized for access to its length, which always occurs in O(1), and
/// modifications to its head, which always occur in O(1).  Access to the elements occurs in O(n).
///
/// Unlike an Array, a List can potentially represent an infinite sequence of values.  Because the
/// List holds these values in a lazy manner, certain primitives like iteration or reversing the 
/// list will force evaluation of the entire list.  For infinite lists this can lead to a program 
/// diverging.
public struct List<A> {
	let len : Int
	let next : () -> (head : A, tail : List<A>)

	/// Constructs a potentially infinite list.
	init(@autoclosure(escaping) _ next : () -> (head : A, tail : List<A>), isEmpty : Bool = false) {
		self.len = isEmpty ? 0 : -1
		self.next = next
	}

	/// Constructs the empty list.
	///
	/// Attempts to access the head or tail of this list in an unsafe manner will throw an exception.
	public init() {
		self.init((error("Attempted to access the head of the empty list."), error("Attempted to access the tail of the empty list.")), isEmpty: true)
	}

	/// Construct a list with a given head and tail.
	public init(_ head : A, _ tail : List<A> = List<A>()) {
		if tail.len == -1 {
			self.len = -1
		} else {
			self.len = tail.len.successor()
		}
		self.next = { (head, tail) }
	}

	/// Appends an element onto the front of a list.
	public static func cons(head : A, tail : List<A>) -> List<A> {
		return List(head, tail)
	}

	/// Destructures a list.  If the list is empty, the result is Nil.  If the list contains a value
	/// the result is Cons(head, tail).
	public var match : ListMatcher<A> {
		if self.len == 0 {
			return .Nil
		}
		let (hd, tl) = self.next()
		return .Cons(hd, tl)
	}

	/// Indexes into an array.
	///
	/// Indexing into the empty list will throw an exception.
	public subscript(n : UInt) -> A {
		switch self.match {
		case .Nil:
			return error("Cannot extract an element from an empty list.")
		case let .Cons(x, _) where n == 0:
			return x
		case let .Cons(_, xs):
			return xs[n - 1]
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
	public static func replicate(n : UInt, value : A) -> List<A> {
		var l = List<A>()
		for _ in 0..<n {
			l = List.cons(value, tail: l)
		}
		return l
	}

	/// Returns the first element in the list, or None if the list is empty.
	public var head : Optional<A> {
		switch self.match {
		case .Nil:
			return .None
		case let .Cons(head, _):
			return .Some(head)
		}
	}

	/// Returns the tail of the list, or None if the list is empty.
	public var tail : Optional<List<A>> {
		switch self.match {
		case .Nil:
			return .None
		case let .Cons(_, tail):
			return .Some(tail)
		}
	}

	/// Returns an array of all initial segments of the receiver, shortest first
	public var inits : List<List<A>> {
		return self.reduce(List<List<A>>(), combine: { xss, x in
			return List<List<A>>([], xss.map { List(x, $0) })
		})
	}
	
	/// Returns an array of all final segments of the receiver, longest first
	public var tails : List<List<A>> {
		return self.reduce(List<List<A>>(), combine: { x, y in
			return List<List<A>>.pure(List(y, x.head!)) + x
		})
	}

	/// Returns whether or not the receiver is the empty list.
	public var isEmpty : Bool {
		return self.len == 0
	}

	/// Returns whether or not the receiver has a countable number of elements.
	///
	/// It may be dangerous to attempt to iterate over an infinite list of values because the loop
	/// will never terminate.
	public var isFinite : Bool {
		return self.len != -1
	}

	/// Yields a new list by applying a function to each element of the receiver.
	public func map<B>(f : A -> B) -> List<B> {
		switch self.match {
		case .Nil:
			return []
		case let .Cons(hd, tl):
			return List<B>(f(hd), tl.map(f))
		}
	}

	/// Appends two lists together.
	///
	/// If the receiver is infinite, the result of this function will be the receiver itself.
	public func append(rhs : List<A>) -> List<A> {
		switch self.match {
		case .Nil:
			return rhs
		case let .Cons(x, xs):
			return List.cons(x, tail: xs.append(rhs))
		}
	}

	/// Maps a function over a list and concatenates the results.
	public func concatMap<B>(f : A -> List<B>) -> List<B> {
		return self.reduce({ l, r in l.append(f(r)) }, initial: List<B>())
	}

	/// Returns a list of elements satisfying a predicate.
	public func filter(p : A -> Bool) -> List<A> {
		switch self.match {
		case .Nil:
			return []
		case let .Cons(x, xs):
			return p(x) ? List(x, xs.filter(p)) : xs.filter(p)
		}
	}

	/// Applies a binary operator to reduce the elements of the receiver to a single value.
	public func reduce<B>(f : B -> A -> B, initial : B) -> B {
		switch self.match {
		case .Nil:
			return initial
		case let .Cons(x, xs):
			return xs.reduce(f, initial: f(initial)(x))
		}
	}

	/// Applies a binary operator to reduce the elements of the receiver to a single value.
	public func reduce<B>(f : (B, A) -> B, initial : B) -> B {
		switch self.match {
		case .Nil:
			return initial
		case let .Cons(x, xs):
			return xs.reduce(f, initial: f(initial, x))
		}
	}

	/// Returns a list of successive applications of a function to the elements of the receiver.
	///
	/// e.g.
	///
	///     [x0, x1, x2, ...].scanl(f, initial: z) == [z, f(z)(x0), f(f(z)(x0))(x1), f(f(f(z)(x2))(x1))(x0)]
	///       [1, 2, 3, 4, 5].scanl(+, initial: 0) == [0, 1, 3, 6, 10, 15]
	///
	public func scanl<B>(f : B -> A -> B, initial : B) -> List<B> {
		switch self.match {
		case .Nil:
			return List<B>(initial)
		case let .Cons(x, xs):
			return List<B>.cons(initial, tail: xs.scanl(f, initial: f(initial)(x)))
		}
	}

	/// Returns a list of successive applications of a function to the elements of the receiver.
	///
	/// e.g.
	///
	///     [x0, x1, x2, ...].scanl(f, initial: z) == [z, f(z, x0), f(f(z, x0), x1), f(f(f(z, x2), x1), x0)]
	///       [1, 2, 3, 4, 5].scanl(+, initial: 0) == [0, 1, 3, 6, 10, 15]
	///
	public func scanl<B>(f : (B, A) -> B, initial : B) -> List<B> {
		switch self.match {
		case .Nil:
			return List<B>(initial)
		case let .Cons(x, xs):
			return List<B>.cons(initial, tail: xs.scanl(f, initial: f(initial, x)))
		}
	}

	/// Like scanl but draws its initial value from the first element of the receiver itself.
	public func scanl1(f : A -> A -> A) -> List<A> {
		switch self.match {
		case .Nil:
			return []
		case let .Cons(x, xs):
			return xs.scanl(f, initial: x)
		}
	}

	/// Like scanl but draws its initial value from the first element of the receiver itself.
	public func scanl1(f : (A, A) -> A) -> List<A> {
		switch self.match {
		case .Nil:
			return []
		case let .Cons(x, xs):
			return xs.scanl(f, initial: x)
		}
	}

	/// Returns the first n elements of the receiver.
	public func take(n : UInt) -> List<A> {
		if n == 0 {
			return []
		}

		switch self.match {
		case .Nil:
			return []
		case let .Cons(x, xs):
			return List.cons(x, tail: xs.take(n - 1))
		}
	}

	/// Returns the remaining list after dropping n elements from the receiver.
	public func drop(n : UInt) -> List<A> {
		if n == 0 {
			return self
		}

		switch self.match {
		case .Nil:
			return []
		case let .Cons(_, xs):
			return xs.drop(n - 1)
		}
	}

	/// Returns a tuple of the first n elements and the remainder of the list.
	public func splitAt(n : UInt) -> (List<A>, List<A>) {
		return (self.take(n), self.drop(n))
	}

	/// Takes a separator and a list and intersperses that element throughout the list.
	///
	///     ["a","b","c","d","e"].intersperse(",") == ["a",",","b",",","c",",","d",",","e"]
	public func intersperse(item : A) -> List<A> {
		func prependToAll(sep : A, l : List<A>) -> List<A> {
			switch l.match {
			case .Nil:
				return List()
			case.Cons(let x, let xs):
				return List(sep, List(x, prependToAll(sep, l: xs)))
			}
		}
		switch self.match {
		case .Nil:
			return List()
		case .Cons(let x, let xs):
			return List(x, prependToAll(item, l: xs))
		}
	}
	
	/// Returns a list of the longest prefix of elements satisfying a predicate.
	public func takeWhile(p : A -> Bool) -> List<A> {
		switch self.match {
		case .Nil:
			return []
		case .Cons(let x, let xs):
			if p(x) {
				return List.cons(x, tail: xs.takeWhile(p))
			}
			return []
		}
	}

	/// Returns a list of the remaining elements after the longest prefix of elements satisfying a
	/// predicate has been removed.
	public func dropWhile(p : A -> Bool) -> List<A> {
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

	/// Takes a list and groups its arguments into sublists of duplicate elements found next to each
	/// other according to an equality predicate.
	public func groupBy(p : A -> A -> Bool) -> List<List<A>> {
		switch self.match {
		case .Nil:
			return []
		case .Cons(let x, let xs):
			let (ys, zs) = xs.span(p(x))
			let l = List(x, ys)
			return List<List<A>>(l, zs.groupBy(p))
		}
	}
	
	/// Takes a list and groups its arguments into sublists of duplicate elements found next to each
	/// other according to an equality predicate.
	public func groupBy(p : (A, A) -> Bool) -> List<List<A>> {
		return self.groupBy(curry(p))
	}
	
	/// Returns a tuple where the first element is the longest prefix of elements that satisfy a
	/// given predicate and the second element is the remainder of the list:
	///
	///     [1, 2, 3, 4, 1, 2, 3, 4].span(<3) == ([1, 2],[3, 4, 1, 2, 3, 4])
	///     [1, 2, 3].span(<9)                == ([1, 2, 3],[])
	///     [1, 2, 3].span(<0)                == ([],[1, 2, 3])
	///
	///     span(list, p) == (takeWhile(list, p), dropWhile(list, p))
	public func span(p : A -> Bool) -> (List<A>, List<A>) {
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
	
	/// Returns a tuple where the first element is the longest prefix of elements that do not
	/// satisfy a given predicate and the second element is the remainder of the list:
	///
	/// `extreme(_:)` is the dual to span(_:)` and satisfies the law
	///
	///     self.extreme(p) == self.span((!) • p)
	public func extreme(p : A -> Bool) -> (List<A>, List<A>) {
		return self.span { ((!) • p)($0) }
	}
	
	/// Returns the elements of the receiver in reverse order.
	///
	/// For infinite lists this function will diverge.
	public func reverse() -> List<A> {
		return self.reduce(flip(List.cons), initial: [])
	}

	/// Given a predicate, searches the list until it find the first match, and returns that,
	/// or None if no match was found.
	///
	/// For infinite lists this function will diverge.
	public func find(pred: A -> Bool) -> Optional<A> {
		for x in self {
			if pred(x) {
				return x
			}
		}
		return nil
	}

	/// For an associated list, such as [(1,"one"),(2,"two")], takes a function (pass the identity 
	/// function) and a key and returns the value for the given key, if there is one, or None 
	/// otherwise.
	public func lookup<K : Equatable, V>(ev : A -> (K, V), key : K) -> Optional<V> {
		return (snd • ev) <^> self.find({ ev($0).0 == key })
	}

	/// Returns a List of an infinite number of iteratations of applications of a function to an
	/// initial value.
	public static func iterate(f : A -> A, initial : A) -> List<A> {
		return List((initial, self.iterate(f, initial: f(initial))))
	}

	/// Cycles a finite list into an infinite list.
	public func cycle() -> List<A> {
		let (hd, tl) = self.next()
		return List((hd, (tl + [hd]).cycle()))
	}
	
	/// Maps a predicate over a list.  For the result to be true, the predicate must be satisfied at
	/// least once by an element of the list.
	public func any(f : (Element -> Bool)) -> Bool {
		return self.map(f).or
	}
	
	/// Maps a predicate over a list.  For the result to be true, the predicate must be satisfied by
	/// all elemenets of the list.
	public func all(f : (Element -> Bool)) -> Bool {
		return self.map(f).and
	}
}

// File radar: If these lines are uncommented the compiler throws spurious "Redundant Conformance to
// Foo errors in the rest of the file.
//
//extension List where A : Equatable {
//	/// Takes two lists and returns true if the first string is a prefix of the second string.
//	public func isPrefixOf(r : List<A>) -> Bool {
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
//	public func isSuffixOf(r : List<A>) -> Bool {
//		return self.reverse().isPrefixOf(r.reverse())
//	}
//	
//	/// Takes two lists and returns true if the first string is contained entirely anywhere in the
//	/// second string.
//	public func isInfixOf(r : List<A>) -> Bool {
//		return r.tails.any(self.isPrefixOf)
//	}
//	
//	/// Takes two strings and drops items in the first from the second.  If the first string is not a
//	/// prefix of the second string this function returns Nothing.
//	public func stripPrefix(r : List<A>) -> Optional<List<A>> {
//		switch (self.match, r.match) {
//		case (.Nil, _):
//			return .Some(r)
//		case (.Cons(let x, let xs), .Cons(let y, _)) where x == y:
//			return xs.stripPrefix(xs)
//		default:
//			return .None
//		}
//	}
//	
//	/// Takes two strings and drops items in the first from the end of the second.  If the first
//	/// string is not a suffix of the second string this function returns nothing.
//	public func stripSuffix(r : List<A>) -> Optional<List<A>> {
//		return self.reverse().stripPrefix(r.reverse()).map({ $0.reverse() })
//	}
//	
//	/// Takes a list and groups its arguments into sublists of duplicate elements found next to each
//	/// other.
//	///
//	///     group([0, 1, 1, 2, 3, 3, 4, 5, 6, 7, 7]) == [[0], [1, 1], [2], [3, 3], [4], [5], [6], [7, 7]]
//	public var group : List<List<A>> {
//		return self.groupBy { a in { b in a == b } }
//	}
//}

extension List where A : BooleanType {
	/// Returns the conjunction of a list of Booleans.
	public var and : Bool {
		return self.reduce(true) { $0.boolValue && $1.boolValue }
	}
	
	/// Returns the dijunction of a list of Booleans.
	public var or : Bool {
		return self.reduce(false) { $0.boolValue || $1.boolValue }
	}
}

/// Flattens a list of lists into a single lists.
public func concat<A>(xss : List<List<A>>) -> List<A> {
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

extension List : ArrayLiteralConvertible {
	public typealias Element = A

	public init(fromArray arr : [Element]) {
		var xs : [A] = []
		var g = arr.generate()
		while let x : A = g.next() {
			xs.append(x)
		}

		var l = List()
		for x in xs.reverse() {
			l = List(x, l)
		}
		self = l
	}

	public init(arrayLiteral s : Element...) {
		self.init(fromArray: s)
	}
}

public final class ListGenerator<A> : GeneratorType {
	var l : List<A>
	
	public func next() -> Optional<A> {
		if l.len == 0 {
			return nil
		}
		
		let (hd, tl) = l.next()
		l = tl
		return hd
	}
	
	public init(_ l : List<A>) {
		self.l = l
	}
}

extension List : SequenceType {
	public typealias Generator = ListGenerator<A>

	public func generate() -> ListGenerator<A> {
		return ListGenerator(self)
	}
}

extension List : CollectionType {
	public typealias Index = UInt
	
	public var startIndex : UInt { return 0 }
	
	public var endIndex : UInt {
		return self.isFinite ? self.count : error("An infinite list has no end index.")
	}
}

extension List : CustomStringConvertible {
	public var description : String {
		if self.isFinite {
			return self.map({ String.init($0) }).intersperse(", ").reduce("", combine: +)
		}
		return "[...]"
	}
}

/// MARK: Control.*

extension List : Functor {
	public typealias B = Any
	public typealias FB = List<B>

	public func fmap<B>(f : (A -> B)) -> List<B> {
		return self.map(f)
	}
}

public func <^> <A, B>(f : A -> B, l : List<A>) -> List<B> {
	return l.fmap(f)
}

extension List : Pointed {
	public static func pure(a: A) -> List<A> {
		return List(a, [])
	}
}

extension List : Applicative {
	public typealias FA = List<A>
	public typealias FAB = List<A -> B>

	public func ap<B>(f : List<A -> B>) -> List<B> {
		return concat(f.map(self.map))
	}
}

public func <*> <A, B>(f : List<(A -> B)>, l : List<A>) -> List<B> {
	return l.ap(f)
}

extension List : Monad {
	public func bind<B>(f : A -> List<B>) -> List<B> {
		return self.concatMap(f)
	}
}

public func >>- <A, B>(l : List<A>, f : A -> List<B>) -> List<B> {
	return l.bind(f)
}
