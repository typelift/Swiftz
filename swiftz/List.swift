//
//  List.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Basis

public enum ListD<A> {
	case Nil
	case Cons(A, List<A>)
}

/// A recursive List, with the same basic usage as Array.
/// This is not currently possible with a bit of misdirection, hence the Box class.
public final class List<A> : K1<A> {
	let value : A?
	let tail : List<A>?
	let cnt : UInt = 0

	init(_ head : A?, _ tail : List<A>?) {
		self.value = head
		self.tail = tail
		self.cnt = (tail == nil) ? 0 : tail!.cnt + 1
	}

	public func destruct() -> ListD<A> {
		if self.cnt == 0 {
			return .Nil
		}
		return .Cons(value!, tail ?? null())
	}
}

public func null<A>() -> List<A> {
	return List(nil, nil)
}

public func cons<A>(h: A) -> List<A> -> List<A> {
	return { t in List(h, t) }
}

/// Returns the first element in the list, or None, if the list is empty.
public func head<A>(l : List<A>) -> A {
	switch l.destruct() {
		case .Nil:
			assert(false, "Cannot take the head of an empty list.")
		case .Cons(let x, _):
			return x
	}
}

/// Returns the tail of the list, or None if the list is Empty.
public func tail<A>(l : List<A>) -> List<A> {
	switch l.destruct() {
		case .Nil:
			assert(false, "Cannot take the tail of an empty list.")
		case .Cons(_, let xs):
			return xs
	}
}

/// Returns the length of the list.
public func length<A>(l : List<A>) -> UInt {
	return l.cnt
}

/// Takes a binary function, a starting value, and a list of values, then folds the function over
/// the list from left to right to yield a final value.
public func foldl<A, B>(f: B -> A -> B)(z: B)(l: List<A>) -> B {
	switch l.destruct() {
		case .Nil:
			return z
		case .Cons(let x, let xs):
			return foldl(f)(z: f(z)(x))(l: xs)
	}
}

/// Takes a binary operator, a starting value, and a list of values, then folds the function over
/// the list from left to right to yield a final value.
public func foldl<A, B>(f: (B, A) -> B)(z: B)(l: List<A>) -> B {
	switch l.destruct() {
		case .Nil:
			return z
		case .Cons(let x, let xs):
			return foldl(f)(z: f(z, x))(l: xs)
	}
}

/// Takes a binary function and a list of values, then folds the function over the list from left
/// to right.  It takes its initial value from the head of the list.
///
/// Because this function draws its initial value from the head of a list, it is non-total with
/// respect to the empty list.
public func foldl1<A>(f: A -> A -> A)(l: List<A>) -> A {
	switch l.destruct() {
		case .Cons(let x, let xs) where length(xs) == 0:
			return x
		case .Cons(let x, let xs):
			return foldl(f)(z: x)(l: xs)
		case .Nil:
			assert(false, "Cannot invoke foldl1 with an empty list.")
	}
}

/// Takes a binary operator and a list of values, then folds the function over the list from left
/// to right.  It takes its initial value from the head of the list.
///
/// Because this function draws its initial value from the head of a list, it is non-total with
/// respect to the empty list.
public func foldl1<A>(f: (A, A) -> A)(l: List<A>) -> A {
	switch l.destruct() {
		case .Cons(let x, let xs) where length(xs) == 0:
			return x
		case .Cons(let x, let xs):
			return foldl(f)(z: x)(l: xs)
		case .Nil:
			assert(false, "Cannot invoke foldl1 with an empty list.")
	}
}

/// Takes a binary function, a starting value, and a list of values, then folds the function over
/// the list from right to left to yield a final value.
public func foldr<A, B>(k: A -> B -> B)(z: B)(l: List<A>) -> B {
	switch l.destruct() {
		case .Nil:
			return z
		case .Cons(let x, let xs):
			return k(x)(foldr(k)(z: z)(l: xs))
	}
}

/// Takes a binary operator, a starting value, and a list of values, then folds the function over
/// the list from right to left to yield a final value.
public func foldr<A, B>(k: (A, B) -> B)(z: B)(l: List<A>) -> B {
	switch l.destruct() {
		case .Nil:
			return z
		case .Cons(let x, let xs):
			return k(x, foldr(k)(z: z)(l: xs))
	}
}

/// Takes a binary function and a list of values, then folds the function over the list from right
/// to left.  It takes its initial value from the head of the list.
///
/// Because this function draws its initial value from the head of a list, it is non-total with
/// respect to the empty list.
public func foldr1<A>(f: A -> A -> A)(l: List<A>) -> A {
	switch l.destruct() {
		case .Cons(let x, let xs) where length(xs) == 0:
			return x
		case .Cons(let x, let xs):
			return f(x)(foldr1(f)(l: xs))
		case .Nil:
			assert(false, "Cannot invoke foldr1 with an empty list.")
	}
}

/// Takes a binary operator and a list of values, then folds the function over the list from right
/// to left.  It takes its initial value from the head of the list.
///
/// Because this function draws its initial value from the head of a list, it is non-total with
/// respect to the empty list.
public func foldr1<A>(f: (A, A) -> A)(l: List<A>) -> A {
	switch l.destruct() {
		case .Cons(let x, let xs) where length(xs) == 0:
			return x
		case .Cons(let x, let xs):
			return f(x, foldr1(f)(l: xs))
		case .Nil:
			assert(false, "Cannot invoke foldr1 with an empty list.")
	}
}

/// Reverse the list
public func reverse<A>(l : List<A>) -> List<A> {
	return foldl(flip(cons))(z: null())(l: l)
}


public func ==<A : Equatable>(lhs : List<A>, rhs : List<A>) -> Bool {
	switch (lhs.destruct(), rhs.destruct()) {
		case (.Nil, .Nil):
			return true
		case let (.Cons(lHead, lTail), .Cons(rHead, rTail)):
			return lHead == rHead && lTail == rTail
		default:
			return false
	}
}

extension List : ArrayLiteralConvertible {
	public class func convertFromArrayLiteral(elements: A...) -> List<A> {
		return convertFromArrayLiteral(elements)
	}

	// destruct() is not getting linked for some reason.
	public class func convertFromArrayLiteral(elements: [A]) -> List<A> {
		if elements.count == 0 {
			return null()
		}
		return cons(head(elements))(convertFromArrayLiteral(elements))
	}
}


public final class ListGenerator<A> : K1<A>, GeneratorType {
	var l : List<A>
	public func next() -> A? {
		switch l.destruct() {
			case .Nil:
				return nil
			case .Cons(let hd, let tl):
				self.l = tl
				return hd
		}
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
		let x = List.fmap({ "\($0)" })(self)
		return "[\(x)]"
	}
}

/// A struct that serves as a Functor for the above List data type.
/// This is necessary since we don't yet have higher kinded types.
extension List : Functor {
	typealias B = Any
	typealias FA = List<A>
	typealias FB = List<B>

	public class func fmap<B>(f : A -> B) -> List<A> -> List<B> {
		return { l in
			switch l.destruct() {
				case .Nil:
					return null()
				case .Cons(let hd, let tl):
					return cons(f(hd))(List.fmap(f)(l.tail!))
			}
		}
	}
}

public func <%><A, B>(f : A -> B, l : List<A>) -> List<B> {
	return List.fmap(f)(l)
}

public func <% <A, B>(x : A, l : List<B>) -> List<A> {
	return List.fmap(const(x))(l)
}


