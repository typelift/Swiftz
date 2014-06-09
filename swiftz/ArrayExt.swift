//
//  ArrayExt.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

// Array extensions

// segfaults. rdar://17148872

func mapFlatten<A>(xs: Array<A?>) -> Array<A> {
  var w = Array<A>()
  xs.map({ (c: A?) -> A? in
    if let x = c {
      w.append(x)
    } else {
      // nothing
    }
    return c // TODO: oh no... mutability
  })
  return w
}

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
