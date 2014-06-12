//
//  ArrayExt.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

// Array extensions
extension Array {
     func safeIndex(i: Int) -> T? {
          return indexArray(self, i)
     }
}

func mapFlatten<A>(xs: Array<A?>) -> Array<A> {
  var w = Array<A>()
  for c in xs {
    if let x = c {
      w.append(x)
    } else {
      // nothing
    }
  }
  return w
}

func join<A>(xs: Array<Array<A>>) -> Array<A> {
  var w = Array<A>()
  for x in xs {
    for e in x {
      w.append(e)
    }
  }
  return w
}

func indexArray<A>(xs: Array<A>, i: Int) -> A? {
  if i < xs.count && i >= 0 {
    return xs[i]
  } else {
    return nil
  }
}
