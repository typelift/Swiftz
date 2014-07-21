//
//  Box.swift
//  swiftz_core
//
//  Created by Andrew Cobb on 6/9/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

// An immutable box, necessary for recursive datatypes (such as List) to avoid compiler crashes
public class Box<T> {
  let _value : () -> T
    
  public init(_ value : T) {
    self._value = { value }
  }
  
  public var value: T {
    return _value()
  }
  
  public func map<U>(fn: T -> U) -> Box<U> {
    return Box<U>(fn(value)) // TODO: file rdar, type inf fails without <U>
  }
}

@infix public func <^><T, U>(fn: T -> U, x: Box<T>) -> Box<U> {
  return x.map(fn)
}
