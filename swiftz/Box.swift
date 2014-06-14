//
//  Box.swift
//  swiftz
//
//  Created by Andrew Cobb on 6/9/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

// An immutable box, necessary for recursive datatypes (such as List) to avoid compiler crashes
// using struct causes crash. rdar exists. Should be @final, but that also crashes.
/*@final*/ class Box<T> {
    let _value : () -> T
    init(_ value : T) {
        self._value = { value }
    }
  
    var value: T {
        get {
            return _value()
        }
    }
}

func isoBox<A, B>() -> Lens<Box<A>, Box<B>, A, B> {
     return Lens { v in IxStore(v.value) { Box($0) } }
}
