//
//  ArrayExt.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

/// MARK: Array extensions

public enum ArrayMatcher<A> {
	case Nil
	case Cons(A, [A])
}

extension Array : Functor {
	typealias A = T
	typealias B = Any
	typealias FB = Array<B>

	public func fmap<B>(f : A -> B) -> [B] {
		return self.map(f)
	}
}

extension Array : Pointed {
	public static func pure(x : A) -> [T] {
		return [x]
	}
}

extension Array : Applicative {
	typealias FAB = Array<A -> B>

	public func ap<B>(f : [A -> B]) -> [B] {
		return f <*> self
	}
}

extension Array : Monad {
	public func bind<B>(f : A -> [B]) -> [B] {
		return self.flatMap(f)
	}
}

extension Array : Foldable {
	public func foldr<B>(k : T -> B -> B, _ i : B) -> B {
		switch self.match {
		case .Nil:
			return i
		case .Cons(let x, let xs):
			return k(x)(xs.foldr(k, i))
		}
	}

	public func foldl<B>(com : B -> T -> B, _ i : B) -> B {
		return self.reduce(i, combine: uncurry(com))
	}

	public func foldMap<M : Monoid>(f : A -> M) -> M {
		return self.foldr(curry(<>) • f, M.mzero)
	}
}

extension Array {
	/// Destructures a list into its constituent parts.
	///
	/// If the given list is empty, this function returns .Nil.  If the list is non-empty, this
	/// function returns .Cons(head, tail)
	public var match : ArrayMatcher<T> {
		if self.count == 0 {
			return .Nil
		} else if self.count == 1 {
			return .Cons(self[0], [])
		}
		let hd = self[0]
		let tl = Array(self[1..<self.count])
		return .Cons(hd, tl)
	}

	/// Returns the tail of the list, or None if the list is empty.
	public var tail : Optional<[T]> {
		switch self.match {
		case .Nil:
			return .None
		case .Cons(_, let xs):
			return .Some(xs)
		}
	}

	/// Takes, at most, a specified number of elements from a list and returns that sublist.
	///
	///     [1,2].take(3)  == [1,2]
	///     [1,2].take(-1) == []
	///     [1,2].take(0)  == []
	public func take(n : Int) -> [T] {
		if n <= 0 {
			return []
		}

		return Array(self[0 ..< min(n, self.count)])
	}

	/// Drops, at most, a specified number of elements from a list and returns that sublist.
	///
	///     [1,2].drop(3)  == []
	///     [1,2].drop(-1) == [1,2]
	///     [1,2].drop(0)  == [1,2]
	public func drop(n : Int) -> [T] {
		if n <= 0 {
			return self
		}

		return Array(self[min(n, self.count) ..< self.count])
	}

	/// Returns an array consisting of the receiver with a given element appended to the front.
	public func cons(lhs : T) -> [T] {
		return [lhs] + self
	}
	
	/// Decomposes the receiver into its head and tail.  If the receiver is empty the result is
	/// `.None`, else the result is `.Just(head, tail)`.
	public var uncons : Optional<(T, [T])> {
		switch self.match {
		case .Nil:
			return .None
		case let .Cons(x, xs):
			return .Some(x, xs)
		}
	}

	/// Safely indexes into an array by converting out of bounds errors to nils.
	public func safeIndex(i : Int) -> T? {
		if i < self.count && i >= 0 {
			return self[i]
		} else {
			return nil
		}
	}

	/// Maps a function over an array that takes pairs of (index, element) to a different element.
	public func mapWithIndex<U>(f : (Int, T) -> U) -> [U] {
		var res = [U]()
		res.reserveCapacity(self.count)
		for i in 0 ..< self.count {
			res.append(f(i, self[i]))
		}
		return res
	}

	/// Folds a reducing function over an array from right to left.
	public func foldRight<U>(z : U, f : (T, U) -> U) -> U {
		var res = z
		for x in self {
			res = f(x, res)
		}
		return res
	}

	/// Takes a binary function, an initial value, and a list and scans the function across each element
	/// of a list accumulating the results of successive function calls applied to reduced values from
	/// the left to the right.
	///
	///     [x1, x2, ...].scanl(z, f) == [z, f(z, x1), f(f(z, x1), x2), ...]
	public func scanl<B>(start : B, r : (B, T) -> B) -> [B] {
		if self.isEmpty {
			return [start]
		}
		var arr = [B]()
		arr.append(start)
		var reduced = start
		for x in self {
			reduced = r(reduced, x)
			arr.append(reduced)
		}
		return arr
	}

	/// Returns the first element in a list matching a given predicate.  If no such element exists, this
	/// function returns nil.
	public func find(f : (T -> Bool)) -> T? {
		for x in self {
			if f(x) {
				return .Some(x)
			}
		}
		return .None
	}

	/// Returns a tuple containing the first n elements of a list first and the remaining elements
	/// second.
	///
	///     [1,2,3,4,5].splitAt(3) == ([1, 2, 3],[4, 5])
	///     [1,2,3].splitAt(1)     == ([1], [2, 3])
	///     [1,2,3].splitAt(3)     == ([1, 2, 3], [])
	///     [1,2,3].splitAt(4)     == ([1, 2, 3], [])
	///     [1,2,3].splitAt(0)     == ([], [1, 2, 3])
	public func splitAt(n : Int) -> ([T], [T]) {
		return (self.take(n), self.drop(n))
	}

	/// Takes a separator and a list and intersperses that element throughout the list.
	///
	///     ["a","b","c","d","e"].intersperse(",") == ["a",",","b",",","c",",","d",",","e"]
	public func intersperse(item : T) -> [T] {
		func prependAll(item : T, array : [T]) -> [T] {
			var arr = Array([item])
			for i in 0..<(array.count - 1) {
				arr.append(array[i])
				arr.append(item)
			}
			arr.append(array[array.count - 1])
			return arr
		}

		if self.isEmpty {
			return self
		} else if self.count == 1 {
			return self
		} else {
			var array = Array([self[0]])
			array += prependAll(item, array: self.tail!)
			return Array(array)
		}
	}

	/// Maps a predicate over a list.  For the result to be true, the predicate must be satisfied at
	/// least once by an element of the list.
	public func any(f : (T -> Bool)) -> Bool {
		return or(self.map(f))
	}

	/// Maps a predicate over a list.  For the result to be true, the predicate must be satisfied by
	/// all elemenets of the list.
	public func all(f : (A -> Bool)) -> Bool {
		return and(self.map(f))
	}

	/// Returns a tuple with the first elements that satisfy a predicate until that predicate returns
	/// false first, and a the rest of the elements second.
	///
	///     [1, 2, 3, 4, 1, 2, 3, 4].span(<3) == ([1, 2],[3, 4, 1, 2, 3, 4])
	///     [1, 2, 3].span(<9)                == ([1, 2, 3],[])
	///     [1, 2, 3].span(<0)                == ([],[1, 2, 3])
	///
	///     span(list, p) == (takeWhile(list, p), dropWhile(list, p))
	public func span(p : T -> Bool) -> ([T], [T]) {
		switch self.match {
		case .Nil:
			return ([], [])
		case .Cons(let x, let xs):
			if p(x) {
				let (ys, zs) = xs.span(p)
				return (ys.cons(x), zs)
			}
			return ([], self)
		}
	}

	/// Returns a tuple with the first elements that do not satisfy a predicate until that predicate
	/// returns false first, and a the rest of the elements second.
	///
	/// `extreme(_:)` is the dual to span(_:)` and satisfies the law
	///
	///     self.extreme(p) == self.span((!) • p)
	public func extreme(p : T -> Bool) -> ([T], [T]) {
		return self.span { ((!) • p)($0) }
	}

	/// Takes a list and groups its arguments into sublists of duplicate elements found next to each
	/// other according to an equality predicate.
	public func groupBy(p : T -> T -> Bool) -> [[T]] {
		switch self.match {
		case .Nil:
			return []
		case .Cons(let x, let xs):
			let (ys, zs) = xs.span(p(x))
			let l = ys.cons(x)
			return zs.groupBy(p).cons(l)
		}
	}

	/// Takes a list and groups its arguments into sublists of duplicate elements found next to each
	/// other according to an equality predicate.
	public func groupBy(p : (T, T) -> Bool) -> [[T]] {
		return self.groupBy(curry(p))
	}

	/// Returns an array of the first elements that do not satisfy a predicate until that predicate
	/// returns false.
	///
	///     [1, 2, 3, 4, 5, 1, 2, 3].dropWhile(<3) == [3,4,5,1,2,3]
	///     [1, 2, 3].dropWhile(<9)                == []
	///     [1, 2, 3].dropWhile(<0)                == [1,2,3]
	public func dropWhile(p : T -> Bool) -> [T] {
		switch self.match {
		case .Nil:
			return []
		case .Cons(let x, let xs):
			if p(x) {
				return xs.dropWhile(p)
			}
			return self
		}
	}
	
	/// Returns an array of of the remaining elements after dropping the largest suffix of the 
	/// receiver over which the predicate holds.
	///
	///     [1, 2, 3, 4, 5].dropWhileEnd(>3) == [1, 2, 3]
	///     [1, 2, 3, 4, 5, 2].dropWhileEnd(>3) == [1, 2, 3, 4, 5, 2]
	public func dropWhileEnd(p : T -> Bool) -> [T] {
		return self.reduce([T](), combine: { xs, x in p(x) && xs.isEmpty ? [] : xs.cons(x) })
	}

	/// Returns an array of the first elements that satisfy a predicate until that predicate returns
	/// false.
	///
	///     [1, 2, 3, 4, 1, 2, 3, 4].takeWhile(<3) == [1, 2]
	///     [1,2,3].takeWhile(<9)                  == [1, 2, 3]
	///     [1,2,3].takeWhile(<0)                  == []
	public func takeWhile(p : T -> Bool) -> [T] {
		switch self.match {
		case .Nil:
			return []
		case .Cons(let x, let xs):
			if p(x) {
				return xs.takeWhile(p).cons(x)
			}
			return []
		}
	}
}

/// Maps a function over a list of Optionals, applying the function of the optional is Some,
/// discarding the value if it is None and returning a list of non Optional values
public func mapFlatten<A>(xs : [A?]) -> [A] {
	var w = [A]()
	w.reserveCapacity(xs.foldRight(0) { c, n in
		if c != nil {
			return n + 1
		} else {
			return n
		}
	})
	for c in xs {
		if let x = c {
			w.append(x)
		} else {
			// nothing
		}
	}
	return w
}

/// Inserts a list in between the elements of a 2-dimensional array and concatenates the result.
public func intercalate<A>(list : [A], nested : [[A]]) -> [A] {
	return concat(nested.intersperse(list))
}

/// Takes a list and groups its arguments into sublists of duplicate elements found next to each
/// other.
///
///     group([0, 1, 1, 2, 3, 3, 4, 5, 6, 7, 7]) == [[0], [1, 1], [2], [3, 3], [4], [5], [6], [7, 7]]
public func group<A : Equatable>(list : [A]) -> [[A]] {
	return list.groupBy { a in { b in a == b } }
}

/// Returns the conjunction of a list of Booleans.
public func and(list : [Bool]) -> Bool {
	return list.reduce(true) {$0 && $1}
}

/// Returns the dijunction of a list of Booleans.
public func or(list : [Bool]) -> Bool {
	return list.reduce(false) {$0 || $1}
}

/// Concatenate a list of lists.
public func concat<T>(list : [[T]]) -> [T] {
	return list.reduce([], combine: +)
}