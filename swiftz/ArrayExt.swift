//
//  ArrayExt.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

// MARK: Array extensions

///Array subscripting is bad and you should feel bad for using it.
///This is a safe alternative that eleminates out of bounds errors
///and returns an Optional instead.
public func safeIndex<T>(array: Array<T>)(i: Int) -> T? {
	return indexArray(array, i)
}

///Appends an array onto the end of the receiving array.
///Does not mutate the receiving array.
public func concat<T>(#lhs: [T])(#rhs: [T]) -> [T] {
	if rhs.isEmpty {
		return lhs
	}
	else {
		var newArr = Array(lhs)
		newArr.extend(rhs)
		return newArr
	}
}

public func mapWithIndex<T, U>(array: Array<T>)(f: (Int, T) -> U) -> [U] {
	var res = [U]()
	res.reserveCapacity(array.count)
	for i in 0 ..< array.count {
		res.append(f(i, array[i]))
	}
	return res
}

public func foldRight<T, U>(array: Array<T>)(z: U, f: (T, U) -> U) -> U {
	var res = z
	for x in array {
		res = f(x, res)
	}
	return res
}

///scanl is similar to reduce, but returns a list of successive reduced values from the left:
///
///scanl(start, func, [x1, x2, ...] == [start, func(start,x1), func(func(start,x1), x2), ...]
///
///Note that
///
///last((scanl(start,func,list)) == reduce(start,list,func)
public func scanl<B, T>(start:B, list:[T], r:(B, T) -> B) -> [B] {
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

///The find function takes a predicate and a list and returns the first element
///in the list matching the predicate, or None if there is no such element.
public func find<T>(list:[T], f:(T -> Bool)) -> T? {
	for x in list {
		if f(x) {
			return .Some(x)
		}
	}
	return .None
}

///splitAt(n xs) returns a tuple where first element is xs prefix of length n and second element is the
///remainder of the list:
///
///splitAt(3, [1,2,3,4,5]) == ([1,2,3],[4,5])
///
///splitAt(1, [1,2,3]) == ([1],[2,3])
///
///splitAt(3, [1,2,3]) == ([1,2,3],[])
///
///splitAt(4, [1,2,3]) == ([1,2,3],[])
///
///splitAt(0, [1,2,3]) == ([],[1,2,3])
///
///splitAt(-1, [1,2,3]) == ([],[1,2,3])
public func splitAt<T>(index:Int, list:[T]) -> ([T], [T]) {
	switch index {
		case 0..<list.count: return (Array(list[0..<index]), Array(list[index..<list.count]))
		case _:return ([T](), [T]())
	}
}

///The intersperse function takes an element and a list and `intersperses' that element between the elements of
///the list. For example,
///
///intersperse(",", ["a","b","c","d","e"] == ["a",",","b",",","c",",","d",",","e"]
public func intersperse<T>(item:T, list:[T]) -> [T] {
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

///maps a function over a list of Optionals, applying the function of the optional is Some,
///discarding the value if it is None and returning a list of non Optional values
public func mapFlatten<A>(xs: [A?]) -> [A] {
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

///Array subscripting is bad and you should feel bad for using it.
///This is a safe alternative that eleminates out of bounds errors
///and returns an Optional instead.
public func indexArray<A>(xs: [A], i: Int) -> A? {
	if i < xs.count && i >= 0 {
		return xs[i]
	} else {
		return nil
	}
}
///and returns the conjunction of a Boolean list. For the result to be True, the list must be finite; False,
///however, results from a False value at a finite index of a finite or infinite list.
public func and(list: [Bool]) -> Bool {
	return list.reduce(true) {$0 && $1}
}

///or returns the disjunction of a Boolean list. For the result to be False, the list must be finite; True,
///however, results from a True value at a finite index of a finite or infinite list.
public func or(list: [Bool]) -> Bool {
	return list.reduce(false) {$0 || $1}
}


///Applied to a predicate and a list, any determines if any element of the list satisfies the predicate. For
///the result to be False, the list must be finite; True, however, results from a True value for the predicate
///applied to an element at a finite index of a finite or infinite list.
public func any<A>(list: [A], f: (A -> Bool)) -> Bool {
	return or(list.map(f))
}

///Applied to a predicate and a list, all determines if all elements of the list satisfy the predicate. 
///For the result to be True, the list must be finite; False, however, results from a False value for
///the predicate applied to an element at a finite index of a finite or infinite list.
public func all<A>(list: [A], f: (A -> Bool)) -> Bool {
	return and(list.map(f))
}

///Concatenate a list of lists.
public func concat<A>(list: [[A]]) -> [A] {
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


///intercalate(list, nested) is equivalent to concat(intersperse(list, nested)). It inserts the list `list` in between the
///lists in `nested` and concatenates the result.
public func intercalate<A>(list: [A], nested:[[A]]) -> [A] {
	return concat(intersperse(list, nested))
}


///span(list,p) returns a tuple where first element is
///the longest prefix (possibly empty) of `list` of elements that satisfy p and 
///the second element is the remainder of the list:
///
///span([1,2,3,4,1,2,3,4]) {$0 < 3} == ([1,2],[3,4,1,2,3,4])
///
///span([1,2,3]){$0 < 9} == ([1,2,3],[])
///
///span([1,2,3]){$0 < 0} == ([],[1,2,3])
///
///span(list,p) is equivalent to (takeWhile(list,p), dropWhile(list,p))
public func span<A>(list: [A], p: (A -> Bool)) -> ([A], [A]) {
	switch list.count {
		case 0: return (list, list)
		case 1...list.count where p(list.first!):
			let first = list.first!
			let (ys,zs) = span(Array(list[1..<list.count]), p)
			let f = concat(lhs: [first])(rhs: ys)
			return (f,zs)
		default: return ([], list)
	}
}

///The groupBy function is equivalent to group, except you supply your
///own predicate function.
public func groupBy<A>(list:[ A], p: (A -> A -> Bool)) -> [[A]] {
	switch list.count {
		case 0: return []
		case 1...list.count:
			let first = list.first!
			let (ys,zs) = span(Array(list[1..<list.count]), p(first))
			let x = [concat(lhs: [first])(rhs: ys)]
			return concat(lhs: x)(rhs: groupBy(zs, p))
		default: return []
	}
}

///The group function takes a list and returns a list of lists such that the concatenation 
///of the result is equal to the argument. Moreover, each sublist in the result contains
///only equal elements. For example,
///
///group([0,1,1,2,3,3,4,5,6,7,7]) == [[0],[1,1],[2],[3,3],[4],[5],[6],[7,7]]
public func group<A:Equatable>(list: [A]) -> [[A]] {
	return groupBy(list, {a in {b in a == b}})
}

///dropWhile(list,p) returns the suffix remaining after takeWhile(list,p):
///
///dropWhile([1,2,3,4,5,1,2,3]){$0 < 3} == [3,4,5,1,2,3]
///
///dropWhile([1,2,3]){$0 < 9} == []
///
///dropWhile([1,2,3]){$0 < 0} == [1,2,3]
public func dropWhile<A>(list: [A], p: A -> Bool) -> [A] {
	switch list.count {
		case 0: return list
		case 1...list.count where p(list.first!):
			return dropWhile(Array(list[1..<list.count]), p)
		default: return list
	}
}

///takeWhile, applied to a predicate p and a list xs, returns the longest prefix (possibly empty) of xs of elements that satisfy p:
///
///takeWhile([1,2,3,4,1,2,3,4]){$0 < 3} == [1,2]
///
///takeWhile([1,2,3]){$0 < 9} == [1,2,3]
///
///takeWhile([1,2,3]){$0 < 0} == []
public func takeWhile<A>(list: [A], p: A -> Bool) -> [A] {
	switch list.count {
		case 0: return list
		case 1...list.count where p(list.first!):
			return concat(lhs: [list.first!])(rhs: takeWhile(Array(list[1..<list.count]), p))
		default: return []
	}
}
