
//
//  SwiftCheck.swift
//  swiftz
//
//  Created by Maxwell Swadling on 7/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

// quick check for swift

import Foundation

public protocol Arbitrary {
  // TODO: should be a lazy generator
  class func arbitrary() -> [Self]
  // TODO: implement and use shrink()
  func shrink() -> [Self]
}

public func swiftCheck<A: Arbitrary>(f: (A -> Void)) -> Void {
  for x in A.arbitrary() {
    f(x)
  }
}

// instances

extension Int: Arbitrary {
  public static func arbitrary() -> [Int] {
    var xs = [Int.min, 0, Int.max]
    xs.extend((-100..<100))
    return xs
  }

  public func shrink() -> [Int] {
    return []
  }
}

extension String: Arbitrary {
  public static func arbitrary() -> [String] {
    // TODO: should have some emoji in here
    let xs = ["", "\n", "a"]
    return xs
  }

  public func shrink() -> [String] {
    return []
  }
}

extension Array: Arbitrary {
  public static func arbitrary() -> [[Element]] {
    return []
  }

  public func shrink() -> [[Element]] {
    return []
  }
}
