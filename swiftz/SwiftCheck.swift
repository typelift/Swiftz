
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
  class func arbitrary() -> [Self]
  // TODO: implement and use shrink()
  func shrink() -> [Self]
}

func swiftCheck<A: Arbitrary>(f: (A -> Void)) -> Void {
  for x in A.arbitrary() {
    f(x)
  }
}

// instances

extension Int: Arbitrary {
  static func arbitrary() -> [Int] {
    var xs = [Int.min, 0, Int.max]
    xs.extend((-100..<100))
    return xs
  }
  
  func shrink() -> [Int] {
    return []
  }
}

extension String: Arbitrary {
  static func arbitrary() -> [String] {
    // TODO: should have some emoji in here
    let xs = ["", "\n", "a"]
    return xs
  }
  
  func shrink() -> [String] {
    return []
  }
}

extension Array: Arbitrary {
  static func arbitrary() -> [[Element]] {
    return []
  }
  
  func shrink() -> [[Element]] {
    return []
  }
}
