//
//  These.swift
//  swiftz_core
//
//  Created by Robert Widmann on 11/25/14.
//  Copyright (c) 2014 Maxwell Swadling. Lll rights reserved.
//

/// Represents a value with three possiblities: Either is contains a left value, a right value, or
/// both a left and right value (This, That, and Those respectively).
public enum Those<L, R> {
	case This(Box<L>)
	case That(Box<R>)
	case These(Box<L>, Box<R>)

	/// Constructs a This containing a left value.
	public static func this(l : L) -> Those<L, R> {
		return .This(Box(l))
	}

	/// Constructs a That containing a right value.
	public static func that(r : R) -> Those<L, R> {
		return .That(Box(r))
	}

	/// Constructs a These containing a left and right value.
	public static func these(l : L, r: R) -> Those<L, R> {
		return .These(Box(l), Box(r))
	}

	/// Returns whether the receiver contains a left value.
	public func isThis() -> Bool {
		switch self {
		case .This(_):
			return true
		default:
			return false
		}
	}

	/// Returns whether the receiver contains a right value.
	public func isThat() -> Bool {
		switch self {
		case .That(_):
			return true
		default:
			return false
		}
	}

	/// Returns whether the receiver contains both a left and right value.
	public func isThese() -> Bool {
		switch self {
		case .These(_, _):
			return true
		default:
			return false
		}
	}

	/// Case analysis for the Those type.  If there is a left value the first function is applied
	/// to it to yield a result.  If there is a right value the middle function is applied.  If
	/// there is both a left and right value the last function is applied to both.
	public func fold<C>(this : L -> C, that : R -> C, these : (L, R) -> C) -> C {
		switch self {
		case let This(x):
			return this(x.value)
		case let That(x):
			return that(x.value)
		case let These(x, y):
			return these(x.value, y.value)
		}
	}

	/// Extracts values from the receiver filling in any missing values with given default ones.
	public func toTuple(l : L, r : R) -> (L, R) {
		switch self {
		case let This(x):
			return (x.value, r)
		case let That(x):
			return (l, x.value)
		case let These(x, y):
			return (x.value, y.value)
		}
	}
}

/// Merges a those with the same type on the Left and Right into a singular value of that same type.
public func merge<L>(f : L -> L -> L) -> Those<L, L> -> L {
	return { $0.fold(identity, that: identity, these: uncurry(f)) }
}

/// MARK: Equatable

public func ==<L : Equatable, R : Equatable>(lhs: Those<L, R>, rhs: Those<L, R>) -> Bool {
	switch (lhs, rhs) {
	case let (.This(l), .This(r)):
		return l.value == r.value
	case let (.That(l), .That(r)):
		return l.value == r.value
	case let (.These(la, ra), .These(lb, rb)):
		return (la.value == lb.value) && (ra.value == rb.value)
	default:
		return false
	}
}

public func !=<L : Equatable, R : Equatable>(lhs: Those<L, R>, rhs: Those<L, R>) -> Bool {
	return !(lhs == rhs)
}

/// MARK: Bifunctor

extension Those : Bifunctor {
	typealias A = L
	typealias B = Swift.Any
	typealias C = R
	typealias D = Swift.Any
	typealias PAC = Those<A, C>
	typealias PAD = Those<A, D>
	typealias PBC = Those<B, C>
	typealias PBD = Those<B, D>

	public func bimap<B, D>(f : A -> B, _ g : C -> D) -> Those<B, D> {
		switch self {
		case let This(x):
			return .This(Box(f(x.value)))
		case let That(x):
			return .That(Box(g(x.value)))
		case let These(x, y):
			return .These(Box(f(x.value)), Box((g(y.value))))
		}
	}

	public func leftMap<B>(f : A -> B) -> Those<B, C> {
		return self.bimap(f, identity)
	}

	public func rightMap<D>(g : C -> D) -> Those<A, D> {
		return self.bimap(identity, g)
	}
}
