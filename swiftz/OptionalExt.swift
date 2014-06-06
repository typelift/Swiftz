//
//  OptionalExt.swift
//  swiftz
//
//  Created by Maxwell Swadling on 4/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

// warning: flatMap can not be linked. rdar://17149404
extension Optional {
  func flatMap<B>(f: (T -> Optional<B>)) -> Optional<B> {
    return self.maybe(.None, f)
  }

  func maybe<B>(z : B, f : T -> B) -> B {
    switch self {
      case .None: return z
      case let .Some(x): return f(x)
    }
  }
  
  // scala's getOrElse
  func getOrElse(x: T) -> T {
    switch self {
      case .None: return x
      case let .Some(x): return x
    }
  }
}
