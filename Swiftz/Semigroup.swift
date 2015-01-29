//
//  Semigroup.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

/// A Semigroup is a type with a closed, associative, binary operator.
public protocol Semigroup {

    /// An associative binary operator.
    func op(other : Self) -> Self
}

public func sconcat<S: Semigroup>(h : S, t : [S]) -> S {
    return t.reduce(h) { $0.op($1) }
}

/// The Semigroup of comparable values under MIN().
public struct Min<A: Comparable>: Semigroup {
    public let value: () -> A

    public init(_ x: @autoclosure () -> A) {
        value = x
    }

    public func op(other : Min<A>) -> Min<A> {
        if value() < other.value() {
            return self
        } else {
            return other
        }
    }
}

/// The Semigroup of comparable values under MAX().
public struct Max<A: Comparable> : Semigroup {
    public let value: () -> A

    public init(_ x: @autoclosure () -> A) {
        value = x
    }

    public func op(other : Max<A>) -> Max<A> {
        if other.value() < value() {
            return self
        } else {
            return other
        }
    }
}
