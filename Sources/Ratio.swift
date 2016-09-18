//
//  Ratio.swift
//  Swiftz
//
//  Created by Robert Widmann on 8/11/15.
//  Copyright © 2015-2016 TypeLift. All rights reserved.
//

#if !XCODE_BUILD
	import Swiftx
#endif

/// "Arbitrary-Precision" ratios of integers.
///
/// While Int has arbitrary precision in Swift, operations beyond 64-bits are O(inf).
public typealias Rational = Ratio<Int>

/// Represents a `Ratio`nal number with an `IntegralType` numerator and denominator.
public struct Ratio<T : IntegralType> {
	public let numerator, denominator : () -> T

	public init(numerator : @autoclosure @escaping () -> T, denominator : @autoclosure @escaping () -> T) {
		self.numerator = numerator
		self.denominator = denominator
	}

	public static var infinity : Rational {
		return Rational(numerator: 1, denominator: 0)
	}

	public static var NAN : Rational {
		return Rational(numerator: 0, denominator: 0)
	}
}

extension Ratio : Equatable { }

public func == <T : Equatable & IntegralType>(l : Ratio<T>, r : Ratio<T>) -> Bool {
	let lred = reduce(l.numerator(), d: l.denominator())
	let rred = reduce(r.numerator(), d: r.denominator())
	return (lred.numerator() == rred.numerator()) && (rred.denominator() == rred.denominator())
}

extension Ratio : Comparable { }

public func < <T : Equatable & IntegralType>(l : Ratio<T>, r : Ratio<T>) -> Bool {
	return (l.numerator().times(r.denominator())) < (r.numerator().times(l.denominator()))
}

public func <= <T : Equatable & IntegralType>(l : Ratio<T>, r : Ratio<T>) -> Bool {
	return (l.numerator().times(r.denominator())) <= (r.numerator().times(l.denominator()))
}

public func >= <T : Equatable & IntegralType>(l : Ratio<T>, r : Ratio<T>) -> Bool {
	return !(l < r)
}

public func > <T : Equatable & IntegralType>(l : Ratio<T>, r : Ratio<T>) -> Bool {
	return !(l <= r)
}

extension Ratio : NumericType {
	public static var zero : Ratio<T> { return Ratio(numerator: T.zero, denominator: T.one) }
	public static var one : Ratio<T> { return Ratio(numerator: T.one, denominator: T.one) }

	public var signum : Ratio<T> { return Ratio(numerator: self.numerator().signum, denominator: T.one) }
	public var negate : Ratio<T> { return Ratio(numerator: self.numerator().negate, denominator: self.denominator()) }

	public func plus(_ other  : Ratio<T>) -> Ratio<T> {
		return reduce(self.numerator().times(other .denominator()).plus(other .numerator().times(self.denominator())), d: self.denominator().times(other .denominator()))
	}

	public func minus(_ other  : Ratio<T>) -> Ratio<T> {
		return reduce(self.numerator().times(other .denominator()).minus(other .numerator().times(self.denominator())), d: self.denominator().times(other .denominator()))
	}

	public func times(_ other  : Ratio<T>) -> Ratio<T> {
		return reduce(self.numerator().times(other .numerator()), d: self.denominator().times(other .denominator()))
	}
}

/// Implementation Details Follow

private func reduce<T : IntegralType>(_ n : T, d : T) -> Ratio<T> {
	if d == T.zero {
		return undefined()
	}
	let gcd = n.greatestCommonDivisor(d)
	return Ratio(numerator: n.quotient(gcd), denominator: d.quotient(gcd))
}
