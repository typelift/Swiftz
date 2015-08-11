//
//  Ratio.swift
//  Swiftz
//
//  Created by Robert Widmann on 8/11/15.
//  Copyright © 2015 TypeLift. All rights reserved.
//

/// "Arbitrary-Precision" ratios of integers.
///
/// While Int has arbitrary precision in Swift, operations beyond 64-bits are O(inf).
public typealias Rational = Ratio<Int>

public struct Ratio<T : Integral> {
	public let numerator, denominator : () -> T
	
	public init(@autoclosure(escaping) numerator : () -> T, @autoclosure(escaping) denominator : () -> T) {
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

public func == <T : protocol<Equatable, Integral>>(l : Ratio<T>, r : Ratio<T>) -> Bool {
	func reduce(n : T, d : T) -> Ratio<T> {
		if d == T.zero {
			return undefined()
		}
		let gcd = n.greatestCommonDivisor(d)
		return Ratio(numerator: n.quotient(gcd), denominator: d.quotient(gcd))
	}

	let lred = reduce(l.numerator(), d: l.denominator())
	let rred = reduce(r.numerator(), d: r.denominator())
	return (lred.numerator() == rred.numerator()) && (rred.denominator() == rred.denominator())
}

