//
//  Bounded.swift
//  Swiftz
//
//  Created by Robert Widmann on 10/22/14.
//  Copyright (c) 2014-2016 Maxwell Swadling. All rights reserved.
//

#if os(Linux)
	import Glibc
#else
	import Darwin
#endif

/// Bounded types are types that have definable upper and lower limits.  For 
/// types like Int and Float, their limits are the minimum and maximum possible 
/// values representable in their bit-width.  While the definition of a "limit" 
/// is flexible, generally custom types that wish to appear bounded must come 
/// with some kind of supremum or infimum.
public protocol Bounded {
	static func minBound() -> Self
	static func maxBound() -> Self
}

extension Bool : Bounded {
	public static func minBound() -> Bool {
		return false
	}

	public static func maxBound() -> Bool {
		return true
	}
}

extension Character : Bounded {
	public static func minBound() -> Character {
		return "\0"
	}

	public static func maxBound() -> Character {
		return "\u{FFFF}"
	}
}

extension UInt : Bounded {
	public static func minBound() -> UInt {
		return UInt.min
	}

	public static func maxBound() -> UInt {
		return UInt.max
	}
}

extension UInt8 : Bounded {
	public static func minBound() -> UInt8 {
		return UInt8.min
	}

	public static func maxBound() -> UInt8 {
		return UInt8.max
	}
}

extension UInt16 : Bounded {
	public static func minBound() -> UInt16 {
		return UInt16.min
	}

	public static func maxBound() -> UInt16 {
		return UInt16.max
	}
}


extension UInt32 : Bounded {
	public static func minBound() -> UInt32 {
		return UInt32.min
	}

	public static func maxBound() -> UInt32 {
		return UInt32.max
	}
}


extension UInt64 : Bounded {
	public static func minBound() -> UInt64 {
		return UInt64.min
	}

	public static func maxBound() -> UInt64 {
		return UInt64.max
	}
}

extension Int : Bounded {
	public static func minBound() -> Int {
		return Int.min
	}

	public static func maxBound() -> Int {
		return Int.max
	}
}

extension Int8 : Bounded {
	public static func minBound() -> Int8 {
		return Int8.min
	}

	public static func maxBound() -> Int8 {
		return Int8.max
	}
}

extension Int16 : Bounded {
	public static func minBound() -> Int16 {
		return Int16.min
	}

	public static func maxBound() -> Int16 {
		return Int16.max
	}
}


extension Int32 : Bounded {
	public static func minBound() -> Int32 {
		return Int32.min
	}

	public static func maxBound() -> Int32 {
		return Int32.max
	}
}


extension Int64 : Bounded {
	public static func minBound() -> Int64 {
		return Int64.min
	}

	public static func maxBound() -> Int64 {
		return Int64.max
	}
}

#if os(OSX)
	extension Float : Bounded {
		public static func minBound() -> Float {
			return Float.leastNormalMagnitude
		}

		public static func maxBound() -> Float {
			return Float.greatestFiniteMagnitude
		}
	}

	extension Double : Bounded {
		public static func minBound() -> Double {
			return Double.leastNormalMagnitude
		}

		public static func maxBound() -> Double {
			return Double.greatestFiniteMagnitude
		}
	}
#endif

/// float.h does not export Float80's limits, nor does the Swift STL.
/// rdar://18404510
//extension Swift.Float80 : Bounded {
//  public static func minBound() -> Swift.Float80 {
//  	return LDBL_MIN
//  }
//
//  public static func maxBound() -> Swift.Float80 {
//  	return LDBL_MAX
//  }
//}
