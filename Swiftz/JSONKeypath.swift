//
//  JSONKeypath.swift
//  Swiftz
//
//  Created by Robert Widmann on 1/29/15.
//  Copyright (c) 2015 TypeLift. All rights reserved.
//

/// Represents a subscript into a nested set of dictionaries.  When used in conjunction with the
/// JSON decoding machinery, this class can be used to combine strings into keypaths to target
/// values inside nested JSON objects.
public struct JSONKeypath : StringLiteralConvertible {
	public typealias StringLiteralType = String
	
	public let path : [String]
	
	public init(_ path : [String]) {
		self.path = path
	}
	
	public init(unicodeScalarLiteral value : UnicodeScalar) {
		self.path = ["\(value)"]
	}
	
	public init(extendedGraphemeClusterLiteral value : String) {
		self.path = [value]
	}
	
	public init(stringLiteral value : String) {
		self.path = [value]
	}
}

extension JSONKeypath : Monoid {
	public static var mempty : JSONKeypath {
		return JSONKeypath([])
	}
	
	public func op(other : JSONKeypath) -> JSONKeypath {
		return JSONKeypath(self.path + other.path)
	}
}

extension JSONKeypath : CustomStringConvertible {
	public var description : String {
		return self.path.intersperse(".").reduce("", combine: +)
	}
}
