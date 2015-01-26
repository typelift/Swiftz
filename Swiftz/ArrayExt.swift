//
//  ArrayExt.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

/// MARK: Array extensions

/// Safely indexes into an array by converting out of bounds errors to nils.
public func safeIndex<T>(array : Array<T>)(i : Int) -> T? {
	return indexArray(array, i)
}

/// Returns the result of concatenating the values in the left and right arrays together.
public func concat<T>(#lhs: [T])(#rhs : [T]) -> [T] {
	return lhs + rhs
}

/// Maps a function over an array that takes pairs of (index, element) to a different element.
public func mapWithIndex<T, U>(array : Array<T>)(f : (Int, T) -> U) -> [U] {
	var res = [U]()
	res.reserveCapacity(array.count)
	for i in 0 ..< array.count {
		res.append(f(i, array[i]))
	}
	return res
}

/// Folds a reducing function over an array from right to left.
public func foldRight<T, U>(array : Array<T>)(z : U, f : (T, U) -> U) -> U {
	var res = z
	for x in array {
		res = f(x, res)
	}
	return res
}

/// Takes a binary function, an initial value, and a list and scans the function across each element
/// of a list accumulating the results of successive function calls applied to reduced values from
/// the left to the right.
///
///     scanl(z, [x1, x2, ...], f) == [z, f(z, x1), f(f(z, x1), x2), ...]
public func scanl<B, T>(start : B, list : [T], r : (B, T) -> B) -> [B] {
	if list.isEmpty {
		return []
	}
	var arr = [B]()
	arr.append(start)
	var reduced = start
	for x in list {
		reduced = r(reduced, x)
		arr.append(reduced)
	}
	return Array(arr)
}

/// Returns the first element in a list matching a given predicate.  If no such element exists, this
/// function returns nil.
public func find<T>(list : [T], f : (T -> Bool)) -> T? {
	for x in list {
		if f(x) {
			return .Some(x)
		}
	}
	return .None
}

/// Returns a tuple containing the first n elements of a list first and the remaining elements
/// second.
///
///     splitAt(3, [1,2,3,4,5]) == ([1,2,3],[4,5])
///     splitAt(1, [1,2,3])     == ([1],[2,3])
///     splitAt(3, [1,2,3])     == ([1,2,3],[])
///     splitAt(4, [1,2,3])     == ([1,2,3],[])
///     splitAt(0, [1,2,3])     == ([],[1,2,3])
public func splitAt<T>(index : Int, list : [T]) -> ([T], [T]) {
	switch index {
	case 0..<list.count: 
		return (Array(list[0..<index]), Array(list[index..<list.count]))
	case _:
		return ([T](), [T]())
	}
}

/// Takes a separator and a list and intersperses that element throughout the list.
///
///     intersperse(",", ["a","b","c","d","e"] == ["a",",","b",",","c",",","d",",","e"]
public func intersperse<T>(item : T, list : [T]) -> [T] {
	func prependAll(item:T, array:[T]) -> [T] {
		var arr = Array([item])
		for i in 0..<(array.count - 1) {
			arr.append(array[i])
			arr.append(item)
		}
		arr.append(array[array.count - 1])
		return arr
	}
	if list.isEmpty {
		return list
	} else if list.count == 1 {
		return list
	} else {
		var array = Array([list[0]])
		array += prependAll(item, Array(list[1..<list.count]))
		return Array(array)
	}
}

//tuples can not be compared with '==' so I will hold off on this for now. rdar://17219478
//public func zip<A,B>(fst:[A], scd:[B]) -> Array<(A,B)> {
//  	var size = min(fst.count, scd.count)
//  	var newArr = Array<(A,B)>()
//  	for x in 0..<size {
//  			newArr += (fst[x], scd[x])
//  	}
//  	return newArr
//}
//
//public func zip3<A,B,C>(fst:[A], scd:[B], thrd:[C]) -> Array<(A,B,C)> {
//  	var size = min(fst.count, scd.count, thrd.count)
//  	var newArr = Array<(A,B,C)>()
//  	for x in 0..<size {
//  			newArr += (fst[x], scd[x], thrd[x])
//  	}
//  	return newArr
//}
//
//public func zipWith<A,B,C>(fst:[A], scd:[B], f:((A, B) -> C)) -> Array<C> {
//  	var size = min(fst.count, scd.count)
//  	var newArr = [C]()
//  	for x in 0..<size {
//  			newArr += f(fst[x], scd[x])
//  	}
//  	return newArr
//}
//
//public func zipWith3<A,B,C,D>(fst:[A], scd:[B], thrd:[C], f:((A, B, C) -> D)) -> Array<D> {
//  	var size = min(fst.count, scd.count, thrd.count)
//  	var newArr = [D]()
//  	for x in 0..<size {
//  			newArr += f(fst[x], scd[x], thrd[x])
//  	}
//  	return newArr
//}

/// Maps a function over a list of Optionals, applying the function of the optional is Some, 
/// discarding the value if it is None and returning a list of non Optional values
public func mapFlatten<A>(xs : [A?]) -> [A] {
	var w = [A]()
	w.reserveCapacity(foldRight(xs)(z: 0) { c, n in
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

/// Safely indexes into an array by converting out of bounds errors to nils.
public func indexArray<A>(xs : [A], i : Int) -> A? {
	if i < xs.count && i >= 0 {
		return xs[i]
	} else {
		return nil
	}
}

/// Returns the conjunction of a list of Booleans.
public func and(list : [Bool]) -> Bool {
	return list.reduce(true) {$0 && $1}
}

/// Returns the dijunction of a list of Booleans.
public func or(list : [Bool]) -> Bool {
	return list.reduce(false) {$0 || $1}
}

/// Maps a predicate over a list.  For the result to be true, the predicate must be satisfied at
/// least once by an element of the list.
public func any<A>(list : [A], f : (A -> Bool)) -> Bool {
	return or(list.map(f))
}

/// Maps a predicate over a list.  For the result to be true, the predicate must be satisfied by
/// all elemenets of the list.
public func all<A>(list : [A], f : (A -> Bool)) -> Bool {
	return and(list.map(f))
}

/// Concatenate a list of lists.
public func concat<A>(list : [[A]]) -> [A] {
	return list.reduce([]) { (start, l) -> [A] in
		return concat(lhs: start)(rhs: l)
	}
}

///Map a function over a list and concatenate the results.
public func concatMap<A,B>(list: [A], f: A -> [B]) -> [B] {
	return list.reduce([]) { (start, l) -> [B] in
		return concat(lhs: start)(rhs: f(l))
	}
}


/// Inserts a list in between the elements of a 2-dimensional array and concatenates the result.
public func intercalate<A>(list : [A], nested : [[A]]) -> [A] {
	return concat(intersperse(list, nested))
}


/// Returns a tuple with the first elements that satisfy a predicate until that predicate returns
/// false first, and a the rest of the elements second.
///
///     span([1, 2, 3, 4, 1, 2, 3, 4]) { <3 } == ([1, 2],[3, 4, 1, 2, 3, 4])
///     span([1, 2, 3]) { <9 }                == ([1, 2, 3],[])
///     span([1, 2, 3]) { <0 }                == ([],[1, 2, 3])
///
///     span(list, p) == (takeWhile(list, p), dropWhile(list, p))
public func span<A>(list : [A], p : (A -> Bool)) -> ([A], [A]) {
	switch list.count {
	case 0: 
		return (list, list)
	case 1...list.count where p(list.first!):
		let first = list.first!
		let (ys,zs) = span(Array(list[1..<list.count]), p)
		let f = concat(lhs: [first])(rhs: ys)
		return (f,zs)
	default: 
		return ([], list)
	}
}

/// Takes a list and groups its arguments into sublists of duplicate elements found next to each
/// other according to an equality predicate.
public func groupBy<A>(list : [A], p : (A -> A -> Bool)) -> [[A]] {
	switch list.count {
	case 0: 
		return []
	case 1...list.count:
		let first = list.first!
		let (ys,zs) = span(Array(list[1..<list.count]), p(first))
		let x = [concat(lhs: [first])(rhs: ys)]
		return concat(lhs: x)(rhs: groupBy(zs, p))
	default: 
		return []
	}
}


/// Takes a list and groups its arguments into sublists of duplicate elements found next to each
/// other.
///
///     group([0, 1, 1, 2, 3, 3, 4, 5, 6, 7, 7]) == [[0], [1, 1], [2], [3, 3], [4], [5], [6], [7, 7]]
public func group<A:Equatable>(list : [A]) -> [[A]] {
	return groupBy(list, { a in { b in a == b } })
}

/// Returns a list of the first elements that do not satisfy a predicate until that predicate
/// returns false.
///
///     dropWhile([1, 2, 3, 4, 5, 1, 2, 3]){ <3 } == [3,4,5,1,2,3]
///     dropWhile([1, 2, 3]){ <9 }                == []
///     dropWhile([1, 2, 3]){ <0 }                == [1,2,3]
public func dropWhile<A>(list : [A], p : A -> Bool) -> [A] {
	switch list.count {
	case 0: 
		return list
	case 1...list.count where p(list.first!):
		return dropWhile(Array(list[1..<list.count]), p)
	default: 
		return list
	}
}

/// Returns a list of the first elements that satisfy a predicate until that predicate returns
/// false.
///
///     takeWhile([1, 2, 3, 4, 1, 2, 3, 4]){ <3 } == [1, 2]
///     takeWhile([1,2,3]){ <9 }                  == [1, 2, 3]
///     takeWhile([1,2,3]){ <0 }                  == []
public func takeWhile<A>(list: [A], p: A -> Bool) -> [A] {
	switch list.count {
	case 0: 
		return list
	case 1...list.count where p(list.first!):
		return concat(lhs: [list.first!])(rhs: takeWhile(Array(list[1..<list.count]), p))
	default: 
		return []
	}
}
