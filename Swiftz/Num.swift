//
//  Num.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//


/// `Num`eric types.
public protocol Num {
	static var zero : Self { get }
	static var one : Self { get }
	var signum : Self { get }
	var negate : Self { get }
	func plus(other : Self) -> Self
	func minus(other : Self) -> Self
	func times(other : Self) -> Self
}

extension Int : Num {
	public static var zero : Int { return 0 }
	public static var one : Int { return 1 }
	public var signum : Int {
		if self < 0 {
			return -1
		} else if self > 0 {
			return 1
		}
		return 0
	}
	public var negate : Int { return -self }
	public func plus(other : Int) -> Int { return self + other }
	public func minus(other : Int) -> Int { return self - other }	
	public func times(other : Int) -> Int { return self * other }
}

extension Int8 : Num {
	public static var zero : Int8 { return 0 }
	public static var one : Int8 { return 1 }
	public var signum : Int8 {
		if self < 0 {
			return -1
		} else if self > 0 {
			return 1
		}
		return 0
	}
	public var negate : Int8 { return -self }
	public func plus(other : Int8) -> Int8 { return self + other }
	public func minus(other : Int8) -> Int8 { return self - other }	
	public func times(other : Int8) -> Int8 { return self * other }
}

extension Int16 : Num {
	public static var zero : Int16 { return 0 }
	public static var one : Int16 { return 1 }
	public var signum : Int16 {
		if self < 0 {
			return -1
		} else if self > 0 {
			return 1
		}
		return 0
	}
	public var negate : Int16 { return -self }
	public func plus(other : Int16) -> Int16 { return self + other }
	public func minus(other : Int16) -> Int16 { return self - other }	
	public func times(other : Int16) -> Int16 { return self * other }
}

extension Int32 : Num {
	public static var zero : Int32 { return 0 }
	public static var one : Int32 { return 1 }
	public var signum : Int32 {
		if self < 0 {
			return -1
		} else if self > 0 {
			return 1
		}
		return 0
	}
	public var negate : Int32 { return -self }
	public func plus(other : Int32) -> Int32 { return self + other }
	public func minus(other : Int32) -> Int32 { return self - other }	
	public func times(other : Int32) -> Int32 { return self * other }
}

extension Int64 : Num {
	public static var zero : Int64 { return 0 }
	public static var one : Int64 { return 1 }
	public var signum : Int64 {
		if self < 0 {
			return -1
		} else if self > 0 {
			return 1
		}
		return 0
	}
	public var negate : Int64 { return -self }
	public func plus(other : Int64) -> Int64 { return self + other }
	public func minus(other : Int64) -> Int64 { return self - other }	
	public func times(other : Int64) -> Int64 { return self * other }
}

extension UInt : Num {
	public static var zero : UInt { return 0 }
	public static var one : UInt { return 1 }
	public var signum : UInt {
		if self > 0 {
			return 1
		}
		return 0
	}
	public var negate : UInt { return undefined() }
	public func plus(other : UInt) -> UInt { return self + other }
	public func minus(other : UInt) -> UInt { return self - other }	
	public func times(other : UInt) -> UInt { return self * other }
}

extension UInt8 : Num {
	public static var zero : UInt8 { return 0 }
	public static var one : UInt8 { return 1 }
	public var signum : UInt8 {
		if self > 0 {
			return 1
		}
		return 0
	}
	public var negate : UInt8 { return undefined() }
	public func plus(other : UInt8) -> UInt8 { return self + other }
	public func minus(other : UInt8) -> UInt8 { return self - other }	
	public func times(other : UInt8) -> UInt8 { return self * other }
}

extension UInt16 : Num {
	public static var zero : UInt16 { return 0 }
	public static var one : UInt16 { return 1 }
	public var signum : UInt16 {
		if self > 0 {
			return 1
		}
		return 0
	}
	public var negate : UInt16 { return undefined() }
	public func plus(other : UInt16) -> UInt16 { return self + other }
	public func minus(other : UInt16) -> UInt16 { return self - other }	
	public func times(other : UInt16) -> UInt16 { return self * other }
}

extension UInt32 : Num {
	public static var zero : UInt32 { return 0 }
	public static var one : UInt32 { return 1 }
	public var signum : UInt32 {
		if self > 0 {
			return 1
		}
		return 0
	}
	public var negate : UInt32 { return undefined() }
	public func plus(other : UInt32) -> UInt32 { return self + other }
	public func minus(other : UInt32) -> UInt32 { return self - other }	
	public func times(other : UInt32) -> UInt32 { return self * other }
}

extension UInt64 : Num {
	public static var zero : UInt64 { return 0 }
	public static var one : UInt64 { return 1 }
	public var signum : UInt64 {
		if self > 0 {
			return 1
		}
		return 0
	}
	public var negate : UInt64 { return undefined() }
	public func plus(other : UInt64) -> UInt64 { return self + other }
	public func minus(other : UInt64) -> UInt64 { return self - other }	
	public func times(other : UInt64) -> UInt64 { return self * other }
}


public protocol Real : Num, Comparable { }

/// Numeric types that support division.
public protocol Integral : Real {
	func quotientRemainder(_ : Self) -> (Self, Self)
}

extension Integral {
	public func quotient(d : Self) -> Self {
		return self.quotientRemainder(d).0
	}

	public func remainder(d : Self) -> Self {
		return self.quotientRemainder(d).1
	}
	
	public func divide(d : Self) -> Self {
		return self.divMod(d).0
	}
	
	public func mod(d : Self) -> Self {
		return self.divMod(d).1
	}
	
	public func divMod(d : Self) -> (Self, Self) {
		let (q, r) = self.quotientRemainder(d)
		if r.signum == d.signum.negate {
			return (q.minus(Self.one), r.plus(d))
		}
		return (q, r)
	}
}


