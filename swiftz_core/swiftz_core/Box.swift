//
//  Box.swift
//  swiftz_core
//
//  Created by Andrew Cobb on 6/9/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

/// An immutable reference type holding a singular value.
///
/// Boxes are often used when the Swift compiler cannot infer the size of a struct or enum because
/// one of its generic types is being used as a member.
public final class Box<T> {
	private let val : @autoclosure () -> T
	public var value: T { return val() }

	public init(_ value : T) {
		self.val = value
	}

	// Type inference fails here.  rdar://19347652
	public func map<U>(f : T -> U) -> Box<U> {
		return Box<U>(f(value))
	}
}

/// Fmap | Applies a function to the value of the receiver to yield a new box.
public func <^><T, U>(f: T -> U, x: Box<T>) -> Box<U> {
	return x.map(f)
}

extension Box : Printable {
	public var description: String {
		return "Box(\(toString(value)))"
	}
}
