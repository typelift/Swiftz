//
//  HList.swift
//  Swiftz
//
//  Created by Maxwell Swadling on 19/06/2014.
//  Copyright (c) 2014-2016 Maxwell Swadling. All rights reserved.
//

#if !XCODE_BUILD
	import Operadics
	import Swiftx
#endif

/// An HList can be thought of like a tuple, but with list-like operations on 
/// the types.  Unlike tuples there is no simple construction syntax as with the
/// `(,)` operator.  But what HLists lack in convenience they gain in 
/// flexibility.
///
/// An HList is a purely static entity.  All its attributes including its 
/// length, the type of each element, and compatible operations on said elements
/// exist fully at compile time.  HLists, like regular lists, support folds, 
/// maps, and appends, only at the type rather than term level.
public protocol HList {
	associatedtype Head
	associatedtype Tail

	static var isNil : Bool { get }
	static var length : Int { get }
}

/// The cons HList node.
public struct HCons<H, T : HList> : HList {
	public typealias Head = H
	public typealias Tail = T

	public let head : H
	public let tail : T

	public init(h : H, t : T) {
		head = h
		tail = t
	}

	public static var isNil : Bool {
		return false
	}

	public static var length : Int {
		return Tail.length.advanced(by: 1)
	}
}

/// The Nil HList node.
public struct HNil : HList {
	public typealias Head = Never
	public typealias Tail = Never

	public init() {}

	public static var isNil : Bool {
		return true
	}

	public static var length : Int {
		return 0
	}
}

/// `HAppend` is a type-level append of two `HList`s.  They are instantiated 
/// with the type of the first list (XS), the type of the second list (YS) and 
/// the type of the result (XYS).  When constructed, `HAppend` provides a safe 
/// append operation that yields the appropriate HList for the given types.
public struct HAppend<XS, YS, XYS> {
	public let append : (XS, YS) -> XYS

	private init(_ append : @escaping (XS, YS) -> XYS) {
		self.append = append
	}

	/// Creates an HAppend that appends Nil to a List.
	public static func makeAppend<L : HList>() -> HAppend<HNil, L, L> {
		return HAppend<HNil, L, L> { (_, l) in return l }
	}

	/// Creates an HAppend that appends two non-HNil HLists.
	public static func makeAppend<T, A : HList, B : HList, C : HList>(h : HAppend<A, B, C>) -> HAppend<HCons<T, A>, B, HCons<T, C>> {
		return HAppend<HCons<T, A>, B, HCons<T, C>> { (c, l) in
			return HCons(h: c.head, t: h.append(c.tail, l))
		}
	}
}

/// `HMap` is a type-level map of a function (F) over an `HList`.  An `HMap` 
/// must, at the very least, takes values of its input type (A) to values of its
/// output type (R).  The function parameter (F) does not necessarily have to be
/// a function, and can be used as an index for extra information that the map 
/// function may need in its computation.
public struct HMap<F, A, R> {
	public let map : (F, A) -> R

	public init(_ map : @escaping (F, A) -> R) {
		self.map = map
	}

	/// Returns an `HMap` that leaves all elements in the HList unchanged.
	public static func identity<T>() -> HMap<(), T, T> {
		return HMap<(), T, T> { (_, x) in
			return x
		}
	}

	/// Returns an `HMap` that applies a function to the elements of an HList.
	public static func apply<T, U>() -> HMap<(T) -> U, T, U> {
		return HMap<(T) -> U, T, U> { (f, x) in
			return f(x)
		}
	}

	/// Returns an `HMap` that composes two functions, then applies the new 
	/// function to elements of an `HList`.
	public static func compose<X, Y, Z>() -> HMap<(), ((X) -> Y, (Y) -> Z), (X) -> Z> {
		return HMap<(), ((X) -> Y, (Y) -> Z), (X) -> Z> { (_, fs) in
			return fs.1 • fs.0
		}
	}

	/// Returns an `HMap` that creates an `HCons` node out of a tuple of the 
	/// head and tail of an `HList`.
	public static func hcons<H, T : HList>() -> HMap<(), (H, T), HCons<H, T>> {
		return HMap<(), (H, T), HCons<H, T>> { (_, p) in
			return HCons(h: p.0, t: p.1)
		}
	}

	/// Returns an `HMap` that uses an `HAppend` operation to append two 
	/// `HList`s together.
	public static func happend<A, B, C>() -> HMap<HAppend<A, B, C>, (A, B), C> {
		return HMap<HAppend<A, B, C>, (A, B), C> { (f, p) in
			return f.append(p.0, p.1)
		}
	}
}

/// `HFold` is a type-level right fold over the values in an `HList`.  Like an 
/// `HMap`, an HFold carries a context (of type G).  The actual fold takes 
/// values of type V and an accumulator A to values of type R.
///
/// Using an `HFold` necessitates defining the type of its starting and ending 
/// data.  For example, a fold that reduces 
/// `HCons<(Int) -> Int, HCons<(Int) -> Int, HCons<(Int) -> Int, HNil>>>` to 
/// `(Int) -> Int` through composition will define two `typealias`es:
///
///     public typealias FList = HCons<(Int) -> Int, HCons<(Int) -> Int, HCons<(Int) -> Int, HNil>>>
///
///     public typealias FBegin = HFold<(), (Int) -> Int, FList, (Int) -> Int>
///     public typealias FEnd = HFold<(), (Int) -> Int, HNil, (Int) -> Int>
///
/// The fold above doesn't depend on a context, and carries values of type 
/// `(Int) -> Int`, contained in a list of type `FList`, to an `HNil` node and 
/// an ending value of type `(Int) -> Int`.
public struct HFold<G, V, A, R> {
	public let fold : (G, V, A) -> R

	private init(fold : @escaping (G, V, A) -> R) {
		self.fold = fold
	}

	/// Creates an `HFold` object that folds a function over an `HNil` node.
	///
	/// This operation returns the starting value of the fold.
	public static func makeFold<G, V>() -> HFold<G, V, HNil, V> {
		return HFold<G, V, HNil, V> { (f, v, n) in
			return v
		}
	}

	/// Creates an `HFold` object that folds a function over an `HCons` node.
	public static func makeFold<H, G, V, T : HList, R, RR>(_ p : HMap<G, (H, R), RR>, _ h : HFold<G, V, T, R>) -> HFold<G, V, HCons<H, T>, RR> {
		return HFold<G, V, HCons<H, T>, RR> { (f, v, c) in
			return p.map(f, (c.head, h.fold(f, v, c.tail)))
		}
	}
}

/// Uncomment if Swift decides to allow tuple patterns. rdar://20989362
///// HCons<HCons<...>> Matcher (Induction Step):  If we've hit this overloading, we should have a cons
///// node, or at least something that matches HCons<HNil>
//public func ~=<H : HList where H.Head : Equatable, H.Tail : HList, H.Tail.Head : Equatable, H.Tail.Tail : HList>(pattern : (H.Head, H.Tail), predicate : H) -> Bool {
//	if H.isNil {
//		return false
//	}
//
//	if let p = (predicate as? HCons<H.Head, H.Tail>), let ps = (p.tail as? HCons<H.Tail.Head, H.Tail.Tail>), let pt = (pattern.1 as? HCons<H.Tail.Head, H.Tail.Tail>) {
//		return (p.head == predicate.0) && ((ps.head, ps.tail) ~= pt)
//	} else if let p = (predicate as? HCons<H.Head, H.Tail>), let ps = (p.tail as? HNil) {
//		return (p.head == pattern.0)
//	}
//	return error("Pattern match on HList expected HCons<HSCons<...>> or HCons<HNil> but got neither.")
//}
//
///// HCons<HNil> or HNil Matcher
//public func ~=<H : HList where H.Head : Equatable, H.Tail : HList>(pattern : (H.Head, H.Tail), predicate : H) -> Bool {
//	if H.isNil {
//		return false
//	}
//	if let p = (predicate as? HCons<H.Head, H.Tail>) {
//		return (p.head == pattern.0)
//	} else 	if let p = (predicate as? HNil) {
//		return false
//	}
//	return error("Pattern match on HList expected HCons<HNil> or HNil but got neither.")
//}
//
///// HNil matcher.
//public func ~=<H : HList>(pattern : (), predicate : H) -> Bool {
//	return H.isNil
//}
