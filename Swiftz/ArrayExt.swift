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
	public typealias A = Element
	public typealias B = Any
	public typealias FB = Array<B>

	public func fmap<B>(f : A -> B) -> [B] {
		return self.map(f)
	}
}

extension Array : Pointed {
	public static func pure(x : A) -> [Element] {
		return [x]
	}
}

extension Array : Applicative {
	public typealias FAB = Array<A -> B>

	public func ap<B>(f : [A -> B]) -> [B] {
		return f <*> self
	}
}

extension Array : Monad {
	public func bind<B>(f : A -> [B]) -> [B] {
		return self.flatMap(f)
	}
}

extension Array : MonadPlus {
	public static var mzero : Array<Element> {
		return []
	}
	
	public func mplus(other : Array<Element>) -> Array<Element> {
		return self + other
	}
}

extension Array : MonadZip {
	public typealias C = Any
	public typealias FC = Array<C>
	
	public typealias FTAB = Array<(A, B)>
	
	public func mzip<B>(ma : Array<B>) -> Array<(A, B)> {
		return Array<(A, B)>(zip(self, ma))
	}
	
	public func mzipWith<B, C>(other : Array<B>, _ f : A -> B -> C) -> Array<C> {
		return self.mzip(other).map(uncurry(f))
	}
	
	public static func munzip<B>(ftab : Array<(A, B)>) -> (Array<A>, Array<B>) {
		return (ftab.map(fst), ftab.map(snd))
	}
}

extension Array : Foldable {
	public func foldr<B>(k : Element -> B -> B, _ i : B) -> B {
		switch self.match {
		case .Nil:
			return i
		case .Cons(let x, let xs):
			return k(x)(xs.foldr(k, i))
		}
	}

	public func foldl<B>(com : B -> Element -> B, _ i : B) -> B {
		return self.reduce(i, combine: uncurry(com))
	}

	public func foldMap<M : Monoid>(f : A -> M) -> M {
		return self.foldr(curry(<>) • f, M.mempty)
	}
}

extension Array {
	/// Destructures a list into its constituent parts.
	///
	/// If the given list is empty, this function returns .Nil.  If the list is non-empty, this
	/// function returns .Cons(head, tail)
	public var match : ArrayMatcher<Element> {
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
	public var tail : Optional<[Element]> {
		switch self.match {
		case .Nil:
			return .None
		case .Cons(_, let xs):
			return .Some(xs)
		}
	}
	
	/// Returns an array of all initial segments of the receiver, shortest first
	public var inits : [[Element]] {
		return self.reduce([[Element]](), combine: { xss, x in
			return xss.map { $0.cons(x) }.cons([])
		})
	}
	
	/// Returns an array of all final segments of the receiver, longest first
	public var tails : [[Element]] {
		return self.reduce([[Element]](), combine: { x, y in
			return [x.first!.cons(y)] + x
		})
	}

	/// Takes, at most, a specified number of elements from a list and returns that sublist.
	///
	///     [1,2].take(3)  == [1,2]
	///     [1,2].take(-1) == []
	///     [1,2].take(0)  == []
	public func take(n : Int) -> [Element] {
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
	public func drop(n : Int) -> [Element] {
		if n <= 0 {
			return self
		}

		return Array(self[min(n, self.count) ..< self.count])
	}

	/// Returns an array consisting of the receiver with a given element appended to the front.
	public func cons(lhs : Element) -> [Element] {
		return [lhs] + self
	}
	
	/// Decomposes the receiver into its head and tail.  If the receiver is empty the result is
	/// `.None`, else the result is `.Just(head, tail)`.
	public var uncons : Optional<(Element, [Element])> {
		switch self.match {
		case .Nil:
			return .None
		case let .Cons(x, xs):
			return .Some(x, xs)
		}
	}
	/// Safely indexes into an array by converting out of bounds errors to nils.
	public func safeIndex(i : Int) -> Element? {
		if i < self.count && i >= 0 {
			return self[i]
		} else {
			return nil
		}
	}

	/// Maps a function over an array that takes pairs of (index, element) to a different element.
	public func mapWithIndex<U>(f : (Int, Element) -> U) -> [U] {
		return zip((self.startIndex ..< self.endIndex), self).map(f)
	}

	public func mapMaybe<U>(f : Element -> Optional<U>) -> [U] {
		var res = [U]()
		res.reserveCapacity(self.count)
		self.forEach { x in
			if let v = f(x) {
				res.append(v)
			}
		}
		return res
	}
	
	/// Folds a reducing function over an array from right to left.
	public func foldRight<U>(z : U, f : (Element, U) -> U) -> U {
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
	public func scanl<B>(start : B, r : (B, Element) -> B) -> [B] {
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
	public func find(f : (Element -> Bool)) -> Element? {
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
	public func splitAt(n : Int) -> ([Element], [Element]) {
		return (self.take(n), self.drop(n))
	}

	/// Takes a separator and a list and intersperses that element throughout the list.
	///
	///     ["a","b","c","d","e"].intersperse(",") == ["a",",","b",",","c",",","d",",","e"]
	public func intersperse(item : Element) -> [Element] {
		func prependAll(item : Element, array : [Element]) -> [Element] {
			var arr = Array([item])
			for i in array.startIndex..<array.endIndex.predecessor() {
				arr.append(array[i])
				arr.append(item)
			}
			arr.append(array[array.endIndex.predecessor()])
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
	public func any(f : (Element -> Bool)) -> Bool {
		return self.map(f).or
	}

	/// Maps a predicate over a list.  For the result to be true, the predicate must be satisfied by
	/// all elemenets of the list.
	public func all(f : (Element -> Bool)) -> Bool {
		return self.map(f).and
	}

	/// Returns a tuple where the first element is the longest prefix of elements that satisfy a 
	/// given predicate and the second element is the remainder of the list:
	///
	///     [1, 2, 3, 4, 1, 2, 3, 4].span(<3) == ([1, 2],[3, 4, 1, 2, 3, 4])
	///     [1, 2, 3].span(<9)                == ([1, 2, 3],[])
	///     [1, 2, 3].span(<0)                == ([],[1, 2, 3])
	///
	///     span(list, p) == (takeWhile(list, p), dropWhile(list, p))
	public func span(p : Element -> Bool) -> ([Element], [Element]) {
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

	/// Returns a tuple where the first element is the longest prefix of elements that do not 
	/// satisfy a given predicate and the second element is the remainder of the list:
	///
	/// `extreme(_:)` is the dual to span(_:)` and satisfies the law
	///
	///     self.extreme(p) == self.span((!) • p)
	public func extreme(p : Element -> Bool) -> ([Element], [Element]) {
		return self.span { ((!) • p)($0) }
	}

	/// Takes a list and groups its arguments into sublists of duplicate elements found next to each
	/// other according to an equality predicate.
	public func groupBy(p : Element -> Element -> Bool) -> [[Element]] {
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
	public func groupBy(p : (Element, Element) -> Bool) -> [[Element]] {
		return self.groupBy(curry(p))
	}

	/// Returns an array of the first elements that do not satisfy a predicate until that predicate
	/// returns false.
	///
	///     [1, 2, 3, 4, 5, 1, 2, 3].dropWhile(<3) == [3,4,5,1,2,3]
	///     [1, 2, 3].dropWhile(<9)                == []
	///     [1, 2, 3].dropWhile(<0)                == [1,2,3]
	public func dropWhile(p : Element -> Bool) -> [Element] {
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
	public func dropWhileEnd(p : Element -> Bool) -> [Element] {
		return self.reduce([Element](), combine: { xs, x in p(x) && xs.isEmpty ? [] : xs.cons(x) })
	}

	/// Returns an array of the first elements that satisfy a predicate until that predicate returns
	/// false.
	///
	///     [1, 2, 3, 4, 1, 2, 3, 4].takeWhile(<3) == [1, 2]
	///     [1,2,3].takeWhile(<9)                  == [1, 2, 3]
	///     [1,2,3].takeWhile(<0)                  == []
	public func takeWhile(p : Element -> Bool) -> [Element] {
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

extension Array where Element : Equatable {
	/// Takes two lists and returns true if the first string is a prefix of the second string.
	public func isPrefixOf(r : [Element]) -> Bool {
		switch (self.match, r.match) {
		case (.Cons(let x, let xs), .Cons(let y, let ys)) where (x == y):
			return xs.isPrefixOf(ys)
		case (.Nil, _):
			return true
		default:
			return false
		}
	}
	
	/// Takes two lists and returns true if the first string is a suffix of the second string.
	public func isSuffixOf(r : [Element]) -> Bool {
		return self.reverse().isPrefixOf(r.reverse())
	}
	
	/// Takes two lists and returns true if the first string is contained entirely anywhere in the
	/// second string.
	public func isInfixOf(r : [Element]) -> Bool {
		return r.tails.any(self.isPrefixOf)
	}
	
	/// Takes two strings and drops items in the first from the second.  If the first string is not a
	/// prefix of the second string this function returns Nothing.
	public func stripPrefix(r : [Element]) -> Optional<[Element]> {
		switch (self.match, r.match) {
		case (.Nil, _):
			return .Some(r)
		case (.Cons(let x, let xs), .Cons(let y, _)) where x == y:
			return xs.stripPrefix(xs)
		default:
			return .None
		}
	}
	
	/// Takes two strings and drops items in the first from the end of the second.  If the first
	/// string is not a suffix of the second string this function returns nothing.
	public func stripSuffix(r : [Element]) -> Optional<[Element]> {
		return self.reverse().stripPrefix(r.reverse()).map({ $0.reverse() })
	}
	
	/// Takes a list and groups its arguments into sublists of duplicate elements found next to each
	/// other.
	///
	///     group([0, 1, 1, 2, 3, 3, 4, 5, 6, 7, 7]) == [[0], [1, 1], [2], [3, 3], [4], [5], [6], [7, 7]]
	public var group : [[Element]] {
		return self.groupBy { a in { b in a == b } }
	}
}

extension Array where Element : BooleanType {
	/// Returns the conjunction of a list of Booleans.
	public var and : Bool {
		return self.reduce(true) { $0.boolValue && $1.boolValue }
	}
	
	/// Returns the dijunction of a list of Booleans.
	public var or : Bool {
		return self.reduce(false) { $0.boolValue || $1.boolValue }
	}
}

/// Maps a function over a list of Optionals, applying the function of the optional is Some,
/// discarding the value if it is None and returning a list of non Optional values
public func mapFlatten<A>(xs : [A?]) -> [A] {
	return xs.mapMaybe(identity)
}

/// Inserts a list in between the elements of a 2-dimensional array and concatenates the result.
public func intercalate<A>(list : [A], nested : [[A]]) -> [A] {
	return concat(nested.intersperse(list))
}

/// Concatenate a list of lists.
public func concat<T>(list : [[T]]) -> [T] {
	return list.reduce([], combine: +)
}
