//
//  Unit.swift
//  Swiftz
//
//  Created by Robert Widmann on 12/11/15.
//  Copyright © 2015-2016 TypeLift. All rights reserved.
//

/// A unit type defined as an enum with a single case.
///
/// This type is a stand-in for the actual unit in Swift () because we can't 
/// actually extend ().
public enum Unit { case TT }

extension Unit {
	public var lower : Void {
		return ()
	}
}

extension Unit : CustomStringConvertible, CustomDebugStringConvertible {
	public var description : String { return "()" }
	public var debugDescription : String { return "()" }
}

extension Unit : Equatable { }

public func ==(l : Unit, r : Unit) -> Bool {
	return true
}

public func !=(l : Unit, r : Unit) -> Bool {
	return false
}

extension Unit : Comparable { }

public func <=(l : Unit, r : Unit) -> Bool {
	return true
}

public func >=(l : Unit, r : Unit) -> Bool {
	return true
}

public func <(l : Unit, r : Unit) -> Bool {
	return false
}

public func >(l : Unit, r : Unit) -> Bool {
	return false
}

extension Unit : Hashable {
	public var hashValue : Int {
		return 0
	}
}

extension Unit : Monoid {
	public func op(_ other : Unit) -> Unit {
		return .TT
	}

	public static var mempty : Unit {
		return .TT
	}
}

extension Unit : Bounded {
	public static func minBound() -> Unit {
		return .TT
	}

	public static func maxBound() -> Unit {
		return .TT
	}
}
