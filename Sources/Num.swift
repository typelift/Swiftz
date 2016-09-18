//
//  Num.swift
//  Swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014-2016 Maxwell Swadling. All rights reserved.
//

#if !XCODE_BUILD
	import Swiftx
#endif

/// Numeric types.
public protocol NumericType : Comparable {
	/// The null quantity.
	static var zero : Self { get }
	/// The singular quantity.
	static var one : Self { get }

	/// The magnitude of the quantity.
	var signum : Self { get }
	/// A quantity with the opposing magnitude of the receiver.
	var negate : Self { get }

	/// The quantity produced by adding the given quantity to the receiver.
	func plus(_ : Self) -> Self
	/// The quantity produced by subtracting the given quantity from the receiver.
	func minus(_ : Self) -> Self
	/// The quantity produced by multiplying the receiver by the given quantity.
	func times(_ : Self) -> Self
}

extension NumericType {
	public var signum : Self {
		if self == Self.zero {
			return Self.zero
		} else if self > Self.zero {
			return Self.one
		} else {
			return Self.one.negate
		}
	}

	public var absoluteValue : Self {
		return (self.signum >= Self.zero) ? self : self.negate
	}
}

extension Int : NumericType {
	public static var zero : Int { return 0 }
	public static var one : Int { return 1 }
	public var negate : Int { return -self }
	public func plus(_ other : Int) -> Int { return self + other }
	public func minus(_ other : Int) -> Int { return self - other }
	public func times(_ other : Int) -> Int { return self * other }
}

extension Int8 : NumericType {
	public static var zero : Int8 { return 0 }
	public static var one : Int8 { return 1 }
	public var negate : Int8 { return -self }
	public func plus(_ other : Int8) -> Int8 { return self + other }
	public func minus(_ other : Int8) -> Int8 { return self - other }
	public func times(_ other : Int8) -> Int8 { return self * other }
}

extension Int16 : NumericType {
	public static var zero : Int16 { return 0 }
	public static var one : Int16 { return 1 }
	public var negate : Int16 { return -self }
	public func plus(_ other : Int16) -> Int16 { return self + other }
	public func minus(_ other : Int16) -> Int16 { return self - other }
	public func times(_ other : Int16) -> Int16 { return self * other }
}

extension Int32 : NumericType {
	public static var zero : Int32 { return 0 }
	public static var one : Int32 { return 1 }
	public var negate : Int32 { return -self }
	public func plus(_ other : Int32) -> Int32 { return self + other }
	public func minus(_ other : Int32) -> Int32 { return self - other }
	public func times(_ other : Int32) -> Int32 { return self * other }
}

extension Int64 : NumericType {
	public static var zero : Int64 { return 0 }
	public static var one : Int64 { return 1 }
	public var negate : Int64 { return -self }
	public func plus(_ other : Int64) -> Int64 { return self + other }
	public func minus(_ other : Int64) -> Int64 { return self - other }
	public func times(_ other : Int64) -> Int64 { return self * other }
}

extension UInt : NumericType {
	public static var zero : UInt { return 0 }
	public static var one : UInt { return 1 }
	public var negate : UInt { return undefined() }
	public func plus(_ other : UInt) -> UInt { return self + other }
	public func minus(_ other : UInt) -> UInt { return self - other }
	public func times(_ other : UInt) -> UInt { return self * other }
}

extension UInt8 : NumericType {
	public static var zero : UInt8 { return 0 }
	public static var one : UInt8 { return 1 }
	public var negate : UInt8 { return undefined() }
	public func plus(_ other : UInt8) -> UInt8 { return self + other }
	public func minus(_ other : UInt8) -> UInt8 { return self - other }
	public func times(_ other : UInt8) -> UInt8 { return self * other }
}

extension UInt16 : NumericType {
	public static var zero : UInt16 { return 0 }
	public static var one : UInt16 { return 1 }
	public var negate : UInt16 { return undefined() }
	public func plus(_ other : UInt16) -> UInt16 { return self + other }
	public func minus(_ other : UInt16) -> UInt16 { return self - other }
	public func times(_ other : UInt16) -> UInt16 { return self * other }
}

extension UInt32 : NumericType {
	public static var zero : UInt32 { return 0 }
	public static var one : UInt32 { return 1 }
	public var negate : UInt32 { return undefined() }
	public func plus(_ other : UInt32) -> UInt32 { return self + other }
	public func minus(_ other : UInt32) -> UInt32 { return self - other }
	public func times(_ other : UInt32) -> UInt32 { return self * other }
}

extension UInt64 : NumericType {
	public static var zero : UInt64 { return 0 }
	public static var one : UInt64 { return 1 }
	public var negate : UInt64 { return undefined() }
	public func plus(_ other : UInt64) -> UInt64 { return self + other }
	public func minus(_ other : UInt64) -> UInt64 { return self - other }
	public func times(_ other : UInt64) -> UInt64 { return self * other }
}

/// Numeric types that support full-precision `Rational` conversions.
public protocol RealType : NumericType {
	var toRational : Rational { get }
}

extension Int : RealType {
	public var toRational : Rational { return Rational(numerator: self, denominator: 1) }
}

extension Int8 : RealType {
	public var toRational : Rational { return Rational(numerator: Int(self), denominator: 1) }
}

extension Int16 : RealType {
	public var toRational : Rational { return Rational(numerator: Int(self), denominator: 1) }
}

extension Int32 : RealType {
	public var toRational : Rational { return Rational(numerator: Int(self), denominator: 1) }
}

extension Int64 : RealType {
	public var toRational : Rational { return Rational(numerator: Int(self), denominator: 1) }
}

extension UInt : RealType {
	public var toRational : Rational { return Rational(numerator: Int(self), denominator: 1) }
}

extension UInt8 : RealType {
	public var toRational : Rational { return Rational(numerator: Int(self), denominator: 1) }
}

extension UInt16 : RealType {
	public var toRational : Rational { return Rational(numerator: Int(self), denominator: 1) }
}

extension UInt32 : RealType {
	public var toRational : Rational { return Rational(numerator: Int(self), denominator: 1) }
}

extension UInt64 : RealType {
	public var toRational : Rational { return Rational(numerator: Int(self), denominator: 1) }
}

/// Numeric types that support division.
public protocol IntegralType : RealType {
	/// Simultaneous quotient and remainder.
	func quotientRemainder(_ : Self) -> (quotient : Self, remainder : Self)
}

extension IntegralType {
	public func quotient(_ d : Self) -> Self {
		return self.quotientRemainder(d).quotient
	}

	public func remainder(_ d : Self) -> Self {
		return self.quotientRemainder(d).remainder
	}

	public func divide(_ d : Self) -> Self {
		return self.divMod(d).quotient
	}

	public func mod(_ d : Self) -> Self {
		return self.divMod(d).modulus
	}

	public func divMod(_ d : Self) -> (quotient : Self, modulus : Self) {
		let (q, r) = self.quotientRemainder(d)
		if r.signum == d.signum.negate {
			return (q.minus(Self.one), r.plus(d))
		}
		return (q, r)
	}

	/// Returns the least common multiple of the receiver and a given quantity.
	public func leastCommonMultiple(_ other : Self) -> Self {
		if self == Self.zero || other == Self.zero {
			return Self.zero
		}
		return self.quotient(self.greatestCommonDivisor(other)).times(other).absoluteValue
	}

	/// Returns the greatest common divisor of the receiver and a given quantity.
	///
	/// Unrolled version of tranditionally recursive Euclidean Division algorithm.
	public func greatestCommonDivisor(_ other : Self) -> Self {
		var a = self
		var b = other
		while b != Self.zero {
			let v = b
			b = a.mod(b)
			a = v
		}
		return a
	}
}

extension Int : IntegralType {
	public func quotientRemainder(_ d : Int) -> (quotient : Int, remainder : Int) { return (self / d, self % d) }
}

extension Int8 : IntegralType {
	public func quotientRemainder(_ d : Int8) -> (quotient : Int8, remainder : Int8) { return (self / d, self % d) }
}

extension Int16 : IntegralType {
	public func quotientRemainder(_ d : Int16) -> (quotient : Int16, remainder : Int16) { return (self / d, self % d) }
}

extension Int32 : IntegralType {
	public func quotientRemainder(_ d : Int32) -> (quotient : Int32, remainder : Int32) { return (self / d, self % d) }
}

extension Int64 : IntegralType {
	public func quotientRemainder(_ d : Int64) -> (quotient : Int64, remainder : Int64) { return (self / d, self % d) }
}

extension UInt : IntegralType {
	public func quotientRemainder(_ d : UInt) -> (quotient : UInt, remainder : UInt) { return (self / d, self % d) }
}

extension UInt8 : IntegralType {
	public func quotientRemainder(_ d : UInt8) -> (quotient : UInt8, remainder : UInt8) { return (self / d, self % d) }
}

extension UInt16 : IntegralType {
	public func quotientRemainder(_ d : UInt16) -> (quotient : UInt16, remainder : UInt16) { return (self / d, self % d) }
}

extension UInt32 : IntegralType {
	public func quotientRemainder(_ d : UInt32) -> (quotient : UInt32, remainder : UInt32) { return (self / d, self % d) }
}

extension UInt64 : IntegralType {
	public func quotientRemainder(_ d : UInt64) -> (quotient : UInt64, remainder : UInt64) { return (self / d, self % d) }
}
