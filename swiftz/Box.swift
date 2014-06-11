//
//  Box.swift
//  swiftz
//
//  Created by Andrew Cobb on 6/9/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

// An immutable box, necessary for recursive datatypes (such as List) to avoid compiler crashes
// using struct causes crash. rdar exists.
class Box<T> {
    let value : () -> T
    init(_ value : T) {
        self.value = { value }
    }
}
