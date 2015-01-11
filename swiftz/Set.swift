//
//  Set.swift
//  swiftz
//
//  Created by Terry Lewis II on 6/7/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Darwin

/// An immutable unordered sequence of distinct values.  Values are checked for uniqueness using 
/// their hashes.
public struct Set<A : Hashable> {
	let bucket : Dictionary<A, Bool> = Dictionary()

	var array : [A] {
		var arr = [A]()
		for (key, _) in bucket {
			arr.append(key)
		}
		return arr
	}

	public var count : Int {
		return bucket.count
	}

	/// Returns an empty set.
	public init() { }

	/// Creates a set from an array of objects.
	///
	/// If there are multiple objects contained in the set that are not distinct, the last of any 
	/// such objects are what will remain in the returned set.
	public init(array : [A]) {
		for obj in array {
			bucket[obj] = true
		}
	}

	/// Retrieves a random element from the receiver.
	///
	/// If the receiver has no values this function will return nil.
	public func any() -> A? {
		let ar = self.array
		if ar.isEmpty {
			return nil
		} else {
			let index = Int(arc4random_uniform(UInt32(ar.count)))
			return ar[index]
		}
	}

	/// Returns whether the receiver contains a given value.
	public func contains(item : A) -> Bool {
		if let c = bucket[item] {
			return c
		} else {
			return false
		}
	}

	/// Returns whether the receiver contains all of the items from another set.  That is, returns
	/// whether or not the receiver is the superset of a given set.
	public func containsAll(set : Set<A>) -> Bool {
		var count = 0
		for x in self {
			if let memb = set.member(x) {
				count++
			}
		}

		return self.count == count
	}

	/// Checks whether a given value is in the set.  If it is that value is returned, else nil.
	public func member(item : A) -> A? {
		if self.contains(item) {
			return .Some(item)
		} else {
			return nil
		}
	}

	/// Returns whether the receiver and a given set intersect at any point.
	public func interectsSet(set : Set<A>) -> Bool {
		for x in set {
			if self.contains(x) {
				return true
			}
		}
		return false
	}

	/// Computes and returns the intersection of the receiver and a given set.
	public func intersect(set : Set<A>) -> Set<A> {
		var array = [A]()
		for x in self {
			if let memb = set.member(x) {
				array.append(memb)
			}
		}
		return Set(array:array)
	}

	/// Returns a set containing the receiver's elements minus the elements of a given set.
	public func minus(set : Set<A>) -> Set<A> {
		var array = [A]()
		for x in self {
			if !set.contains(x) {
				array.append(x)
			}
		}
		return Set(array:array)
	}

	/// Computes and returns the union of the reicever and a given set.
	public func union(set : Set<A>) -> Set<A> {
		var current = self.array
		current += set.array
		return Set(array: current)
	}

	/// Appends an item to the set.
	///
	/// If the item already exists the receiver is returned unaltered.
	public func add(item : A) -> Set<A> {
		if contains(item) {
			return self
		} else {
			var arr = array
			arr.append(item)
			return Set(array:arr)
		}
	}

	/// Returns the set of elements in the receiver that pass a given predicate.
	public func filter(f : A -> Bool) -> Set<A> {
		var array = [A]()
		for x in self {
			if f(x) {
				array.append(x)
			}
		}
		return Set(array: array)
	}

	/// Maps a function over the elements of the receiver and aggregates the result in a new set.
	public func map<B>(f : A -> B) -> Set<B> {
		var array = [B]()
		for x in self {
			array.append(f(x))
		}

		return Set<B>(array: array)
	}
}

extension Set : ArrayLiteralConvertible {
	typealias Element = A

	public init(arrayLiteral elements : A...) {
		self.init(array: elements)
	}
}

extension Set : SequenceType {
	public func generate() -> SetGenerator<A> {
		let items = self.array
		return SetGenerator(items: items[0..<items.count])
	}
}

public struct SetGenerator<A> : GeneratorType {
	var items : Slice<A>

	mutating public func next() -> A?	 {
		if items.isEmpty {
			return nil
		}
		let ret = items[0]
		items = items[1..<items.count]
		return ret
	}
}

extension Set : Printable, DebugPrintable {
	public var description: String {
		return "\(self.array)"
	}

	public var debugDescription: String {
		return "\(self.array)"
	}
}

/// MARK: Set Operators

/// Minus | Returns a set containing the receiver's elements minus the elements of a given set.
public func -<A>(lhs : Set<A>, rhs : Set<A>) -> Set<A> {
	return lhs.minus(rhs)
}

/// Intersect | Computes and returns the intersection of the receiver and a given set.
public func ∩<A>(lhs : Set<A>, rhs : Set<A>) -> Set<A> {
	return lhs.intersect(rhs)
}

/// Union | Computes and returns the union of the reicever and a given set.
public func ∪<A>(lhs : Set<A>, rhs : Set<A>) -> Set<A> {
	return lhs.union(rhs)
}

/// MARK: Equatable

public func ==<A: Equatable>(lhs:Set<A>, rhs:Set<A>) -> Bool {
	return lhs.containsAll(rhs) && rhs.containsAll(lhs)
}

public func !=<A: Equatable>(lhs:Set<A>, rhs:Set<A>) -> Bool {
	return !(lhs == rhs)
}
