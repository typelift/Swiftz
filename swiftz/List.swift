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

/// A lazy ordered sequence of values.
///
/// Unlike an Array, a List can potentially represent an infinite sequence of values.
public struct List<A> {
	let len : Int
	let next : () -> (head : A, tail : List<A>)

	/// Constructs a potentially infinite list.
	init(_ next : @autoclosure () -> (head : A, tail : List<A>), isEmpty : Bool = false) {
		self.len = isEmpty ? 0 : -1
		self.next = next
	}

	/// Constructs the empty list.
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

	/// Appends and element onto the front of a list.
	public static func cons(head : A, tail : List<A>) -> List<A> {
		return List(head, tail)
	}

	/// Destructures a list into its constituent parts or Nil.
	public func match() -> ListMatcher<A> {
		if self.len == 0 {
			return .Nil
		}
		let (hd, tl) = self.next()
		return .Cons(hd, tl)
	}

	/// Indexes into an array.
	public subscript(n : UInt) -> A {
		switch self.match() {
		case .Nil:
			return error("Cannot extract an element from an empty list.")
		case let .Cons(x, xs) where n == 0:
			return x
		case let .Cons(x, xs):
			return xs[n - 1]
		}
	}

	/// Creates a list of n repeating values.
	public static func replicate(n : UInt, value : A) -> List<A> {
		var l = List<A>()
		for _ in 0..<n {
			l = List.cons(value, tail: l)
		}
		return l
	}

	/// Returns the first element in the list, or None, if the list is empty.
	public func head() -> Optional<A> {
		switch self.match() {
		case .Nil:
			return .None
		case let .Cons(head, _):
			return .Some(head)
		}
	}

	/// Returns the tail of the list, or None if the list is Empty.
	public func tail() -> Optional<List<A>> {
		switch self.match() {
		case .Nil:
			return .None
		case let .Cons(_, tail):
			return .Some(tail)
		}
	}

	/// Returns whether or not the reciever is the empty list.
	public func isEmpty() -> Bool {
		return self.len == 0
	}

	/// Returns whether or not the reciever is a potentially infinite list.
	public func isFinite() -> Bool {
		return self.len != -1
	}

	/// Returns the length of the list.
	///
	/// For infinite lists this function will throw an exception.
	public func length() -> UInt {
		if self.len == -1 {
			return error("Cannot take the length of an infinite list.")
		}
		return UInt(self.len)
	}

	/// Maps a function over the list.
	public func map<B>(f : A -> B) -> List<B> {
		switch self.match() {
		case .Nil:
			return []
		case let .Cons(hd, tl):
			return List<B>(f(hd), tl.map(f))
		}
	}

	/// Appends two lists together.
	public func append(rhs : List<A>) -> List<A> {
		switch self.match() {
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
		switch self.match() {
		case .Nil:
			return []
		case let .Cons(x, xs):
			return p(x) ? List(x, xs.filter(p)) : xs.filter(p)
		}
	}

	/// Applies a binary operator to reduce the elements of a list to a single value.
	public func reduce<B>(f : B -> A -> B, initial : B) -> B {
		switch self.match() {
		case .Nil:
			return initial
		case let .Cons(x, xs):
			return xs.reduce(f, initial: f(initial)(x))
		}
	}

	/// Applies a binary operator to reduce the elements of a list to a single value.
	public func reduce<B>(f : (B, A) -> B, initial : B) -> B {
		switch self.match() {
		case .Nil:
			return initial
		case let .Cons(x, xs):
			return xs.reduce(f, initial: f(initial, x))
		}
	}

	/// Returns a list of successive applications of a function to the elements of a list.
	///
	/// e.g.
	/// [x0, x1, x2, ...].scanl(f, initial: z) == [z, f(z)(x0), f(f(z)(x0))(x1), f(f(f(z)(x2))(x1))(x0)]
	///
	/// [1, 2, 3, 4, 5].scanl(+, initial: 0) == [0, 1, 3, 6, 10, 15]
	public func scanl<B>(f : B -> A -> B, initial : B) -> List<B> {
		switch self.match() {
		case .Nil:
			return List<B>(initial)
		case let .Cons(x, xs):
			return List<B>.cons(initial, tail: xs.scanl(f, initial: f(initial)(x)))
		}
	}

	/// Returns a list of successive applications of a function to the elements of a list.
	///
	/// e.g.
	/// [x0, x1, x2, ...].scanl(f, initial: z) == [z, f(z, x0), f(f(z, x0), x1), f(f(f(z, x2), x1), x0)]
	///
	/// [1, 2, 3, 4, 5].scanl(+, initial: 0) == [0, 1, 3, 6, 10, 15]
	public func scanl<B>(f : (B, A) -> B, initial : B) -> List<B> {
		switch self.match() {
		case .Nil:
			return List<B>(initial)
		case let .Cons(x, xs):
			return List<B>.cons(initial, tail: xs.scanl(f, initial: f(initial, x)))
		}
	}

	/// Like scanl but draws its initial value from the first element of the list itself.
	public func scanl1(f : A -> A -> A) -> List<A> {
		switch self.match() {
		case .Nil:
			return []
		case let .Cons(x, xs):
			return xs.scanl(f, initial: x)
		}
	}

	/// Like scanl but draws its initial value from the first element of the list itself.
	public func scanl1(f : (A, A) -> A) -> List<A> {
		switch self.match() {
		case .Nil:
			return []
		case let .Cons(x, xs):
			return xs.scanl(f, initial: x)
		}
	}

	/// Returns the first n elements of a list.
	public func take(n : UInt) -> List<A> {
		if n == 0 {
			return []
		}

		switch self.match() {
		case .Nil:
			return []
		case let .Cons(x, xs):
			return List.cons(x, tail: xs.take(n - 1))
		}
	}

	/// Returns the remaining list after dropping n elements from a list.
	public func drop(n : UInt) -> List<A> {
		if n == 0 {
			return self
		}

		switch self.match() {
		case .Nil:
			return []
		case let .Cons(x, xs):
			return xs.drop(n - 1)
		}
	}

	/// Returns a tuple of the first n elements and the remainder of the list.
	public func splitAt(n : UInt) -> (List<A>, List<A>) {
		return (self.take(n), self.drop(n))
	}

	/// Returns a list of the longest prefix of elements satisfying a predicate.
	public func takeWhile(p : A -> Bool) -> List<A> {
		switch self.match() {
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
		switch self.match() {
		case .Nil:
			return []
		case let .Cons(x, xs):
			if p(x) {
				return xs.dropWhile(p)
			}
			return self
		}
	}

	/// Reverse the list
	public func reverse() -> List<A> {
		return self.reduce(flip(List.cons), initial: [])
	}

	/// Given a predicate, searches the list until it find the first match, and returns that,
	/// or None if no match was found.
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
		return { ev($0).1 } <^> self.find({ ev($0).0 == key })
	}

	/// Returns a List of an infinite number of iteratations of applications of a function to a value.
	public static func iterate(f : A -> A, initial : A) -> List<A> {
		return List((initial, iterate(f, initial: f(initial))))
	}

	/// Cycles a finite list into an infinite list.
	public func cycle() -> List<A> {
		let (hd, tl) = self.next()
		return List((hd, (tl + [hd]).cycle()))
	}
}

/// Flattens a list of lists into a single lists.
public func concat<A>(xss : List<List<A>>) -> List<A> {
	return xss.reduce(+, initial: [])
}

/// Appends two lists together.
public func +<A>(lhs : List<A>, rhs : List<A>) -> List<A> {
	return lhs.append(rhs)
}

public func ==<A : Equatable>(lhs : List<A>, rhs : List<A>) -> Bool {
	switch (lhs.match(), rhs.match()) {
	case (.Nil, .Nil):
		return true
	case let (.Cons(lHead, lTail), .Cons(rHead, rTail)):
		return lHead == rHead && lTail == rTail
	default:
		return false
	}
}

extension List : ArrayLiteralConvertible {
	typealias Element = A

	public init(arrayLiteral s: Element...) {
		var xs : [A] = []
		var g = s.generate()
		while let x : A = g.next() {
			xs.append(x)
		}

		var l = List()
		for x in xs.reverse() {
			l = List(x, l)
		}
		self = l
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
	public func generate() -> ListGenerator<A> {
		return ListGenerator(self)
	}
}

extension List : Printable {
	public var description : String {
		var x = ", ".join(self.fmap({ "\($0)" }))
		return "[\(x)]"
	}
}

extension List : Functor {
	typealias B = Any
	typealias FB = List<B>

	public func fmap<B>(f : (A -> B)) -> List<B> {
		return self.map(f)
	}
}

extension List : Applicative {
	typealias FA = List<A>
	typealias FAB = List<A -> B>

	public static func pure(a: A) -> List<A> {
		return List(a, [])
	}

	public func ap<B>(f : List<A -> B>) -> List<B> {
		return concat(f.map({ self.map($0) }))
	}
}

extension List : Monad {
	public func bind<B>(f: A -> List<B>) -> List<B> {
		return self.concatMap(f)
	}
}
