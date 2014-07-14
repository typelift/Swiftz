//
//  Box.swift
//  swiftz_core
//
//  Created by Andrew Cobb on 6/9/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

// An immutable box, necessary for recursive datatypes (such as List) to avoid compiler crashes
@final class Box<T> {
  let _value : () -> T
  init(_ value : T) {
    self._value = { value }
  }
  
  var value: T {
    return _value()
  }
  
  func map<U>(fn: T -> U) -> Box<U> {
    return Box<U>(fn(value)) // TODO: file rdar, type inf fails without <U>
  }
}
