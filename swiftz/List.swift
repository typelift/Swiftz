//
//  List.swift
//  swiftz_core
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

/// A lazy finite sequence of values.
public enum List<A> {
	case Nil
	case Cons(@autoclosure() -> A, @autoclosure() -> List<A>)

	public init() {
		self = .Nil
	}

	/// Construct a list with a given head and tail.
	public init(_ head : A, _ tail : List<A>) {
		self = .Cons(head, tail)
	}

	/// Appends and element onto the front of a list.
	public static func cons(h: A) -> List<A> -> List<A> {
		return { t in List(h, t) }
	}

	public subscript(n : UInt) -> A {
		switch self {
		case .Nil:
			assert(false, "Cannot extract an element from an empty list.")
		case let .Cons(x, xs) where n == 0:
			return x()
		case let .Cons(x, xs):
			return xs()[n - 1]
		}
	}

	/// Creates a list of n repeating values.
	public static func replicate(n : UInt, value : A) -> List<A> {
		var l : List<A> = .Nil
		for _ in 0..<n {
			l = List.cons(value)(l)
		}
		return l
	}

	/// Returns the first element in the list, or None, if the list is empty.
	public func head() -> A? {
		switch self {
		case .Nil:
			return .None
		case let .Cons(head, _):
			return head()
		}
	}

	/// Returns the tail of the list, or None if the list is Empty.
	public func tail() -> List<A>? {
		switch self {
		case .Nil:
			return .None
		case let .Cons(_, tail):
			return tail()
		}
	}

	/// Returns whether or not the reciever is the empty list.
	public func isEmpty() -> Bool {
		switch self {
		case .Nil:
			return true
		default:
			return false
		}
	}

	/// Returns the length of the list.
	public func length() -> Int {
		var c = 0
		for x in self {
			c++
		}
		return c
	}

	/// Maps a function over the list.
	public func map<B>(f : A -> B) -> List<B> {
		var l : List<B> = .Nil
		for x in self.reverse() {
			l = List<B>(f(x), l)
		}
		return l
	}

	/// Maps a function over a list and concatenates the results.
	public func concatMap<B>(f : A -> List<B>) -> List<B> {
		var l : List<B> = .Nil
		for x in self.reverse() {
			l = f(x) + l
		}
		return l
	}

	/// Returns a list of elements satisfying a predicate.
	public func filter(p : A -> Bool) -> List<A> {
		switch self {
		case .Nil:
			return .Nil
		case let .Cons(x, xs):
			return p(x()) ? List(x(), xs().filter(p)) : xs().filter(p)
		}
	}

	/// Applies a binary operator to reduce the elements of a list to a single value.
	public func reduce<B>(f : B -> A -> B, initial: B) -> B {
		var xs = initial
		for x in self {
			xs = f(xs)(x)
		}
		return xs
	}

	/// Applies a binary operator to reduce the elements of a list to a single value.
	public func reduce<B>(f : (B, A) -> B, initial: B) -> B {
		var xs = initial
		for x in self {
			xs = f(xs, x)
		}
		return xs
	}

	/// Returns a list of successive applications of a function to the elements of a list.
	///
	/// e.g.
	/// [x0, x1, x2, ...].scanl(f, initial: z) == [z, f(z)(x0), f(f(z)(x0))(x1), f(f(f(z)(x2))(x1))(x0)]
	///
	/// [1, 2, 3, 4, 5].scanl(+, initial: 0) == [0, 1, 3, 6, 10, 15]
	public func scanl<B>(f : B -> A -> B, initial: B) -> List<B> {
		var acc = initial
		var l : List<B> = .Nil
		for x in self {
			l = List<B>(acc, l)
			acc = f(acc)(x)
		}
		return List<B>(acc, l).reverse()
	}

	/// Like scanl but draws its initial value from the first element of the list itself.
	///
	/// This function is partial with respect to the empty list.
	public func scanl1(f : A -> A -> A) -> List<A> {
		return self.tail()!.scanl(f, initial: self.head()!)
	}

	/// Returns the first n elements of a list.
	public func take(n : UInt) -> List<A> {
		var l = List<A>.Nil
		for x in lazy(0..<n).reverse() {
			l = List(self[x], l)
		}
		return l
	}

	/// Returns the remaining list after dropping n elements from a list.
	public func drop(n : UInt) -> List<A> {
		var l = self
		for x in 0..<n {
			l = l.tail() ?? .Nil
		}
		return l
	}

	/// Returns a tuple of the first n elements and the remainder of the list.
	public func splitAt(n : UInt) -> (List<A>, List<A>) {
		return (self.take(n), self.drop(n))
	}

	/// Returns a list of the longest prefix of elements satisfying a predicate.
	public func takeWhile(p : A -> Bool) -> List<A> {
		var l = List<A>.Nil
		for x in self {
			if !p(x) {
				break
			}
			l = List(x, l)
		}
		return l
	}

	/// Returns a list of the remaining elements after the longest prefix of elements satisfying a
	/// predicate has been removed.
	public func dropWhile(p : A -> Bool) -> List<A> {
		var l = self
		for x in self {
			if p(x) {
				l = l.tail() ?? .Nil
			}
		}
		return l
	}


	/// Reverse the list
	public func reverse() -> List<A> {
		return self.reduce(flip(List.cons), initial: List())
	}

	/// Given a predicate, searches the list until it find the first match, and returns that,
	/// or None if no match was found.
	public func find(pred: A -> Bool) -> A? {
		for x in self {
			if pred(x) {
				return x
			}
		}
		return nil
	}

	/// For an associated list, such as [(1,"one"),(2,"two")], takes a function(pass the identity function)
	/// and a key and returns the value for the given key, if there is one, or None otherwise.
	public func lookup<K: Equatable, V>(ev: A -> (K, V), key: K) -> V? {
		let pred: (K, V) -> Bool = { (k, _) in k == key }
		let val: (K, V) -> V = { (_, v) in v }
		return (({ val(ev($0)) }) <^> self.find({ pred(ev($0)) }))
	}
}

/// Flattens a list of lists into a single lists.
public func concat<A>(xss : List<List<A>>) -> List<A> {
	return xss.reduce(+, initial: .Nil)
}

/// Appends two lists together.
public func +<A>(lhs : List<A>, rhs : List<A>) -> List<A> {
	var l = rhs
	for x in lhs.reverse() {
		l = List(x, l)
	}
	return l
}

public func ==<A : Equatable>(lhs : List<A>, rhs : List<A>) -> Bool {
	switch (lhs, rhs) {
	case (.Nil, .Nil):
		return true
	case let (.Cons(lHead, lTail), .Cons(rHead, rTail)):
		return lHead() == rHead() && lTail() == rTail()
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
	var l : List<A>?
	public func next() -> A? {
		var r = l?.head()
		l = self.l?.tail()
		return r
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
		return List(a, .Nil)
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
