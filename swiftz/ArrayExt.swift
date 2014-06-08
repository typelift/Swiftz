//
//  ArrayExt.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

// Array extensions

// segfaults. rdar://17148872

//func mapFlatten<A>(xs: Array<Optional<A>>) -> Array<A> {
//  var w = Array<A>(self.count)
//  xs.map({ (c: Optional<A>) -> Void in
//    switch c {
//      case .None: ()
//      case let .Some(x): w.append(x)
//    }
//  })
//  return w
//}
//
//func join<A>(xs: Array<Array<A>>) -> Array<A> {
//  var w = Array<A>(self.count)
//  xs.map({ $0.map { w.append($0) } })
//  return w
//}

func ind<A>(xs: Array<A>, i: Int) -> A? {
  if i < xs.count {
    return xs[i]
  } else {
    return nil
  }
}
