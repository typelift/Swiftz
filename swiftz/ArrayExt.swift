//
//  ArrayExt.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

// Array extensions
extension Array {
     public func safeIndex(i: Int) -> T? {
          return indexArray(self, i)
     }
}

public func mapFlatten<A>(xs: [A?]) -> [A] {
  var w = [A]()
  for c in xs {
    if let x = c {
      w.append(x)
    } else {
      // nothing
    }
  }
  return w
}

public func join<A>(xs: [[A]]) -> [A] {
  var w = [A]()
  for x in xs {
    for e in x {
      w.append(e)
    }
  }
  return w
}

public func indexArray<A>(xs: [A], i: Int) -> A? {
  if i < xs.count && i >= 0 {
    return xs[i]
  } else {
    return nil
  }
}
