//
//  Error.swift
//  swiftz_core
//
//  Created by Robert Widmann on 12/23/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

/// Immediately terminates the program with an error message.
///
/// This currently only works in Debug mode, since the underlying assertion is optimized away in Release mode.
public func error<A>(x : String) -> A {
    return assert(false, x) as A
}

/// A special case of error.
///
/// Undefined is often used in place of an actual definition for functions that have yet to be
/// written.  When the compiler calls said function, it will immediately terminate the program until
/// a suitable definition is put in its place.
///
/// For example:
///
///     public func sortBy<A>(cmp : (A, A) -> Bool)(l : [A]) -> [A] {
///         return undefined()
///     }
///
/// The same caveat about compilation modes applies to "undefined" as to "error".
public func undefined<A>() -> A {
	return error("Undefined")
}
