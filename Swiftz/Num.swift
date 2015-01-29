//
//  Num.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//


// Num 'typeclass'

public protocol Num {
	class var zero: Self { get }
    class var one: Self { get }
    func plus(other: Self) -> Self
	func times(other: Self) -> Self
}

extension Int8 : Num {
	public static var zero: Int8 { return 0 }
	public static var one: Int8 { return 1 }
	public func plus(other: Int8) -> Int8 { return self + other }
	public func times(other: Int8) -> Int8 { return self * other }
}

extension Int16 : Num {
	public static var zero: Int16 { return 0 }
	public static var one: Int16 { return 1 }
	public func plus(other: Int16) -> Int16 { return self + other }
	public func times(other: Int16) -> Int16 { return self * other }
}

extension Int32 : Num {
	public static var zero: Int32 { return 0 }
	public static var one: Int32 { return 1 }
	public func plus(other: Int32) -> Int32 { return self + other }
	public func times(other: Int32) -> Int32 { return self * other }
}

extension Int64 : Num {
	public static var zero: Int64 { return 0 }
	public static var one: Int64 { return 1 }
	public func plus(other: Int64) -> Int64 { return self + other }
	public func times(other: Int64) -> Int64 { return self * other }
}

extension UInt8 : Num {
	public static var zero: UInt8 { return 0 }
	public static var one: UInt8 { return 1 }
	public func plus(other: UInt8) -> UInt8 { return self + other }
	public func times(other: UInt8) -> UInt8 { return self * other }
}

extension UInt16 : Num {
	public static var zero: UInt16 { return 0 }
	public static var one: UInt16 { return 1 }
	public func plus(other: UInt16) -> UInt16 { return self + other }
	public func times(other: UInt16) -> UInt16 { return self * other }
}

extension UInt32 : Num {
	public static var zero: UInt32 { return 0 }
	public static var one: UInt32 { return 1 }
	public func plus(other: UInt32) -> UInt32 { return self + other }
	public func times(other: UInt32) -> UInt32 { return self * other }
}

extension UInt64 : Num {
	public static var zero: UInt64 { return 0 }
	public static var one: UInt64 { return 1 }
	public func plus(other: UInt64) -> UInt64 { return self + other }
	public func times(other: UInt64) -> UInt64 { return self * other }
}
