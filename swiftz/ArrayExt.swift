//
//  ArrayExt.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

// Array extensions

func mapFlatten<A>(xs: Array<A?>) -> Array<A> {
  var w = Array<A>()
  xs.map({ (c: A?) -> A? in
    if let x = c {
      w.append(x)
    } else {
      // nothing
    }
    return c // we are making a copy of the array, to not mutate this one.
  })
  return w
}

func join<A>(xs: Array<Array<A>>) -> Array<A> {
  var w = Array<A>()
  xs.map({ $0.map { (e: A) -> A in w.append(e); return e } })
  return w
}

func indexArray<A>(xs: Array<A>, i: Int) -> A? {
  if i < xs.count {
    return xs[i]
  } else {
    return nil
  }
}
