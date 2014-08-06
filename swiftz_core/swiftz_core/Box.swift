//
//  Box.swift
//  swiftz_core
//
//  Created by Andrew Cobb on 6/9/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

// An immutable box, necessary for recursive datatypes (such as List) to avoid compiler crashes
public final class Box<T> {
    private let _value : () -> T
    
    public init(_ value : T) {
        self._value = { value }
    }
    
    public var value: T {
        return _value()
    }
    
    public func map<U>(f: T -> U) -> Box<U> {
        return Box<U>(f(value)) // TODO: file rdar, type inf fails without <U>
    }
}

public func <^><T, U>(f: T -> U, x: Box<T>) -> Box<U> {
    return x.map(f)
}
