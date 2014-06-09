//
//  SwiftCheck.swift
//  swiftz
//
//  Created by Maxwell Swadling on 7/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

// quick check for swift

import Foundation

protocol Arbitrary {
  // TODO: should be a lazy generator
  class func arbitrary() -> Array<Self>
  // TODO: implement and use shrink()
  func shrink() -> Array<Self>
}

func swiftCheck<A: Arbitrary>(f: (A -> Void)) -> Void {
  for x in A.arbitrary() {
    f(x)
  }
}

// instances

extension Int: Arbitrary {
  static func arbitrary() -> Array<Int> {
    var xs = [Int.min, 0, Int.max]
    xs.extend((-100..100))
    return xs
  }
  
  func shrink() -> Array<Int> {
    return []
  }
}

extension String: Arbitrary {
  static func arbitrary() -> Array<String> {
    // TODO: should have some emoji in here
    let xs = ["", "\n", "a"]
    return xs
  }
  
  func shrink() -> Array<String> {
    return []
  }
}

extension Array: Arbitrary {
  static func arbitrary() -> Array<Array<Element>> {
    return []
  }
  
  func shrink() -> Array<Array<Element>> {
    return []
  }
}
