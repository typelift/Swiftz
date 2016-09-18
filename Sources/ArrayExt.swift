//
//  ArrayExt.swift
//  Swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

#if !XCODE_BUILD
	import Operadics
	import Swiftx
#endif

/// MARK: Array extensions

public enum ArrayMatcher<A> {
	case Nil
	case Cons(A, [A])
}

extension Array /*: Functor*/ {
	public typealias A = Element
	public typealias B = Any
	public typealias FB = [B]

	public func fmap<B>(_ f : (A) -> B) -> [B] {
		return self.map(f)
	}
}

extension Array /*: Pointed*/ {
	public static func pure(_ x : A) -> [Element] {
		return [x]
	}
}

extension Array /*: Applicative*/ {
	public typealias FAB = [(A) -> B]

	public func ap<B>(_ f : [(A) -> B]) -> [B] {
		return f <*> self
	}
}

extension Array /*: Cartesian*/ {
	public typealias FTOP = Array<()>
	public typealias FTAB = Array<(A, B)>
	public typealias FTABC = Array<(A, B, C)>
	public typealias FTABCD = Array<(A, B, C, D)>

	public static var unit : Array<()> { return [()] }
	public func product<B>(_ r : Array<B>) -> Array<(A, B)> {
		return self.mzip(r)
	}
	
	public func product<B, C>(_ r : Array<B>, _ s : Array<C>) -> Array<(A, B, C)> {
		return { x in { y in { z in (x, y, z) } } } <^> self <*> r <*> s
	}
	
	public func product<B, C, D>(_ r : Array<B>, _ s : Array<C>, _ t : Array<D>) -> Array<(A, B, C, D)> {
		return { x in { y in { z in { w in (x, y, z, w) } } } } <^> self <*> r <*> s <*> t
	}
}

extension Array /*: ApplicativeOps*/ {
	public typealias C = Any
	public typealias FC = [C]
	public typealias D = Any
	public typealias FD = [D]

	public static func liftA<B>(_ f : @escaping (A) -> B) -> ([A]) -> [B] {
		typealias FAB = (A) -> B
		return { (a : [A]) -> [B] in [FAB].pure(f) <*> a }
	}

	public static func liftA2<B, C>(_ f : @escaping (A) -> (B) -> C) -> ([A]) -> ([B]) -> [C] {
		return { (a : [A]) -> ([B]) -> [C] in { (b : [B]) -> [C] in f <^> a <*> b  } }
	}

	public static func liftA3<B, C, D>(_ f : @escaping (A) -> (B) -> (C) -> D) -> ([A]) -> ([B]) -> ([C]) -> [D] {
		return { (a : [A]) -> ([B]) -> ([C]) -> [D] in { (b : [B]) -> ([C]) -> [D] in { (c : [C]) -> [D] in f <^> a <*> b <*> c } } }
	}
}

extension Array /*: Monad*/ {
	public func bind<B>(_ f : (A) -> [B]) -> [B] {
		return self.flatMap(f)
	}
}

extension Array /*: MonadOps*/ {
	public static func liftM<B>(_ f : @escaping (A) -> B) -> ([A]) -> [B] {
		return { (m1 : [A]) -> [B] in m1 >>- { (x1 : A) in [B].pure(f(x1)) } }
	}

	public static func liftM2<B, C>(_ f : @escaping (A) -> (B) -> C) -> ([A]) -> ([B]) -> [C] {
		return { (m1 : [A]) -> ([B]) -> [C] in { (m2 : [B]) -> [C] in m1 >>- { (x1 : A) in m2 >>- { (x2 : B) in [C].pure(f(x1)(x2)) } } } }
	}

	public static func liftM3<B, C, D>(_ f : @escaping (A) -> (B) -> (C) -> D) -> ([A]) -> ([B]) -> ([C]) -> [D] {
		return { (m1 : [A]) -> ([B]) -> ([C]) -> [D] in { (m2 : [B]) -> ([C]) -> [D] in { (m3 : [C]) -> [D] in m1 >>- { (x1 : A) in m2 >>- { (x2 : B) in m3 >>- { (x3 : C) in [D].pure(f(x1)(x2)(x3)) } } } } } }
	}
}

public func >>->> <A, B, C>(_ f : @escaping (A) -> [B], g : @escaping (B) -> [C]) -> ((A) -> [C]) {
	return { x in f(x) >>- g }
}

public func <<-<< <A, B, C>(g : @escaping (B) -> [C], f : @escaping (A) -> [B]) -> ((A) -> [C]) {
	return f >>->> g
}

extension Array /*: MonadPlus*/ {
	public static var mzero : [Element] {
		return []
	}

	public func mplus(_ other : [Element]) -> [Element] {
		return self + other
	}
}

extension Array /*: MonadZip*/ {
	public typealias FTABL = [(A, B)]

	public func mzip<B>(_ ma : [B]) -> [(A, B)] {
		return [(A, B)](zip(self, ma))
	}

	public func mzipWith<B, C>(_ other : [B], _ f : @escaping (A) -> (B) -> C) -> [C] {
		return self.mzip(other).map(uncurry(f))
	}

	public static func munzip<B>(ftab : [(A, B)]) -> ([A], [B]) {
		return (ftab.map(fst), ftab.map(snd))
	}
}

extension Array /*: Foldable*/ {
	public func foldr<B>(_ k : @escaping (Element) -> (B) -> B, _ i : B) -> B {
		switch self.match {
		case .Nil:
			return i
		case let .Cons(x, xs):
			return k(x)(xs.foldr(k, i))
		}
	}

	public func foldl<B>(_ com : @escaping (B) -> (Element) -> B, _ i : B) -> B {
		return self.reduce(i, uncurry(com))
	}

	public func foldMap<M : Monoid>(_ f : @escaping (A) -> M) -> M {
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
			return .none
		case .Cons(_, let xs):
			return .some(xs)
		}
	}

	/// Returns an array of all initial segments of the receiver, shortest first
	public var inits : [[Element]] {
		return self.reduce([[Element]]()) { xss, x in
			return xss.map { $0.cons(x) }.cons([])
		}
	}

	/// Returns an array of all final segments of the receiver, longest first
	public var tails : [[Element]] {
		return self.reduce([[Element]]()) { x, y in
			return [x.first!.cons(y)] + x
		}
	}

	/// Returns an array consisting of the receiver with a given element appended to the front.
	public func cons(_ lhs : Element) -> [Element] {
		return [lhs] + self
	}

	/// Decomposes the receiver into its head and tail.  If the receiver is empty the result is
	/// `.none`, else the result is `.Just(head, tail)`.
	public var uncons : Optional<(Element, [Element])> {
		switch self.match {
		case .Nil:
			return .none
		case let .Cons(x, xs):
			return .some(x, xs)
		}
	}
	/// Safely indexes into an array by converting out of bounds errors to nils.
	public func safeIndex(_ i : Int) -> Element? {
		if i < self.count && i >= 0 {
			return self[i]
		} else {
			return nil
		}
	}

	/// Maps a function over an array that takes pairs of (index, element) to a different element.
	public func mapWithIndex<U>(_ f : (Int, Element) -> U) -> [U] {
		return zip((self.startIndex ..< self.endIndex), self).map(f)
	}

	public func mapMaybe<U>(_ f : (Element) -> Optional<U>) -> [U] {
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
	public func foldRight<U>(_ z : U, _ f : (Element, U) -> U) -> U {
		var res = z
		for x in self {
			res = f(x, res)
		}
		return res
	}

	/// Takes a binary function, an initial value, and a list and scans the function across each 
	/// element from left to right.  After each pass of the scanning function the output is added to
	/// an accumulator and used in the succeeding scan until the receiver is consumed.
	///
	///     [x1, x2, ...].scanl(z, f) == [z, f(z, x1), f(f(z, x1), x2), ...]
	public func scanl<B>(_ start : B, _ r : (B, Element) -> B) -> [B] {
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

	/// Takes a separator and a list and intersperses that element throughout the list.
	///
	///     ["a","b","c","d","e"].intersperse(",") == ["a",",","b",",","c",",","d",",","e"]
	public func intersperse(_ item : Element) -> [Element] {
		func prependAll(item : Element, array : [Element]) -> [Element] {
			var arr = Array([item])
			for i in array.startIndex..<array.endIndex.advanced(by: -1) {
				arr.append(array[i])
				arr.append(item)
			}
			arr.append(array[array.endIndex.advanced(by: -1)])
			return arr
		}

		if self.isEmpty {
			return self
		} else if self.count == 1 {
			return self
		} else {
			var array = Array([self[0]])
			array += prependAll(item: item, array: self.tail!)
			return Array(array)
		}
	}

	/// Returns a tuple where the first element is the longest prefix of elements that satisfy a
	/// given predicate and the second element is the remainder of the list:
	///
	///     [1, 2, 3, 4, 1, 2, 3, 4].span(<3) == ([1, 2],[3, 4, 1, 2, 3, 4])
	///     [1, 2, 3].span(<9)                == ([1, 2, 3],[])
	///     [1, 2, 3].span(<0)                == ([],[1, 2, 3])
	///
	///     span(list, p) == (takeWhile(list, p), dropWhile(list, p))
	public func span(_ p : (Element) -> Bool) -> ([Element], [Element]) {
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
	public func extreme(_ p : @escaping (Element) -> Bool) -> ([Element], [Element]) {
		return self.span { ((!) • p)($0) }
	}

	/// Takes a list and groups its arguments into sublists of duplicate elements found next to each
	/// other according to an equality predicate.
	public func groupBy(_ p : (Element) -> (Element) -> Bool) -> [[Element]] {
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
	public func groupBy(_ p : @escaping (Element, Element) -> Bool) -> [[Element]] {
		return self.groupBy(curry(p))
	}

	/// Returns an array of the first elements that do not satisfy a predicate until that predicate
	/// returns false.
	///
	///     [1, 2, 3, 4, 5, 1, 2, 3].dropWhile(<3) == [3,4,5,1,2,3]
	///     [1, 2, 3].dropWhile(<9)                == []
	///     [1, 2, 3].dropWhile(<0)                == [1,2,3]
	public func dropWhile(_ p : (Element) -> Bool) -> [Element] {
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
	public func dropWhileEnd(_ p : (Element) -> Bool) -> [Element] {
		return self.reduce([Element](), { xs, x in p(x) && xs.isEmpty ? [] : xs.cons(x) })
	}

	/// Returns an array of the first elements that satisfy a predicate until that predicate returns
	/// false.
	///
	///     [1, 2, 3, 4, 1, 2, 3, 4].takeWhile(<3) == [1, 2]
	///     [1,2,3].takeWhile(<9)                  == [1, 2, 3]
	///     [1,2,3].takeWhile(<0)                  == []
	public func takeWhile(_ p : (Element) -> Bool) -> [Element] {
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
	public func isPrefixOf(_ r : [Element]) -> Bool {
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
	public func isSuffixOf(_ r : [Element]) -> Bool {
		return self.reversed().isPrefixOf(r.reversed())
	}

	/// Takes two lists and returns true if the first string is contained entirely anywhere in the
	/// second string.
	public func isInfixOf(_ r : [Element]) -> Bool {
		if let _ = r.tails.first(where: self.isPrefixOf) {
			return true
		}
		return false
	}

	/// Takes two strings and drops items in the first from the second.  If the first string is not a
	/// prefix of the second string this function returns Nothing.
	public func stripPrefix(_ r : [Element]) -> Optional<[Element]> {
		switch (self.match, r.match) {
		case (.Nil, _):
			return .some(r)
		case (.Cons(let x, let xs), .Cons(let y, _)) where x == y:
			return xs.stripPrefix(xs)
		default:
			return .none
		}
	}

	/// Takes two strings and drops items in the first from the end of the second.  If the first
	/// string is not a suffix of the second string this function returns nothing.
	public func stripSuffix(_ r : [Element]) -> Optional<[Element]> {
		return self.reversed().stripPrefix(r.reversed()).map({ $0.reversed() })
	}

	/// Takes a list and groups its arguments into sublists of duplicate elements found next to each
	/// other.
	///
	///     group([0, 1, 1, 2, 3, 3, 4, 5, 6, 7, 7]) == [[0], [1, 1], [2], [3, 3], [4], [5], [6], [7, 7]]
	public var group : [[Element]] {
		return self.groupBy { a in { b in a == b } }
	}
}

/// MARK: Sequence and SequenceType extensions

extension Sequence {
	/// Maps the array of  to a dictionary given a transformer function that returns
	/// a (Key, Value) pair for the dictionary, if nil is returned then the value is
	/// not added to the dictionary.
	public func mapAssociate<Key : Hashable, Value>(_ f : (Iterator.Element) -> (Key, Value)?) -> [Key : Value] {
		return Dictionary(flatMap(f))
	}
	
	/// Creates a dictionary of Key-Value pairs generated from the transformer function returning the key (the label)
	/// and pairing it with that element.
	public func mapAssociateLabel<Key : Hashable>(_ f : (Iterator.Element) -> Key) -> [Key : Iterator.Element] {
		return Dictionary(map { (f($0), $0) })
	}
}

/// Maps a function over a list of Optionals, applying the function of the optional is Some,
/// discarding the value if it is None and returning a list of non Optional values
public func mapFlatten<A>(_ xs : [A?]) -> [A] {
	return xs.mapMaybe(identity)
}

/// Inserts a list in between the elements of a 2-dimensional array and concatenates the result.
public func intercalate<A>(_ list : [A], nested : [[A]]) -> [A] {
	return concat(nested.intersperse(list))
}

/// Concatenate a list of lists.
public func concat<T>(_ list : [[T]]) -> [T] {
	return list.reduce([], +)
}

public func sequence<A>(_ ms: [Array<A>]) -> Array<[A]> {
	if ms.isEmpty { return [] }
	
	return ms.reduce(Array<[A]>.pure([]), { (n : [[A]], m : [A]) in
		return n.bind { (xs : [A]) in
			return m.bind { (x : A) in
				return Array<[A]>.pure(xs + [x])
			}
		}
	})
}
