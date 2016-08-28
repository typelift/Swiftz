//
//  Functor.swift
//  Swiftz
//
//  Created by Josh Abernathy on 6/7/2014.
//  Copyright (c) 2014 Josh Abernathy. All rights reserved.
//

/// Encapsultes a value that may or may not exist.  A Maybe<A> contains either a value of type A or
/// nothing.
///
/// Because the nil case of Maybe does not indicate any significant information about cause, it may
/// be more appropriate to use Result or Either which have explicit error cases.
@available(*, deprecated, message="Use OptionalExt instead")
public struct Maybe<A>  {
	let value: A?

	var description : String {
		return "\(self.value)"
	}

	public init(_ v : A) {
		self.value = v
	}

	public init() {
		self.value = nil
	}

	/// Constructs a Maybe holding a value.
	public static func just(t : A) -> Maybe<A> {
		return Maybe(t)
	}

	/// Constructs a Maybe with no value.
	public static func none() -> Maybe {
		return Maybe()
	}

	/// Returns whether or not the receiver contains a value.
	public func isJust() -> Bool {
		switch value {
		case .Some(_):
			return true
		case .None:
			return false
		}
	}

	/// Returns whether or not the receiver has no value.
	public func isNone() -> Bool {
		return !isJust()
	}

	/// Forces a value from the receiver.
	///
	/// If the receiver contains no value this function will throw an exception.
	public func fromJust() -> A {
		return self.value!
	}

	/// Takes a default value and a maybe.  If the maybe is empty, the default value is returned.
	/// If the maybe contains a value, that value is returned.
	///
	/// This function is a safer form of fromJust().
	public func fromMaybe(def : A) -> A {
		if self.isNone() {
			return def
		}
		return self.fromJust()
	}

	/// Takes a default value, a function, and a maybe.  If the maybe is Nothing, the default value
	/// is returned.  If the maybe is Just, the function is applied to the value inside.
	public func maybe<B>(def : B, onVal : (A -> B)) -> B {
		if self.isNone() {
			return def
		}
		return onVal(self.fromJust())
	}
}
