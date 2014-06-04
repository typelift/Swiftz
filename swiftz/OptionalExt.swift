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
    switch self {
      case .None: return .None
      case let .Some(x): return f(x)
    }
  }
}
