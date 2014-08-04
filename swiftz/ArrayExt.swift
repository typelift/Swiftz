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

  public func mapWithIndex<U>(f: (Int, T) -> U) -> [U] {
    var res = [U]()
    res.reserveCapacity(count)
    for i in 0 ..< count {
      res.append(f(i, self[i]))
    }
    return res
  }

  public func foldRight<U>(z: U, _ f: (T, U) -> U) -> U {
    var res = z
    for x in self {
      res = f(x, res)
    }
    return res
  }
}

public func mapFlatten<A>(xs: [A?]) -> [A] {
  var w = [A]()
  w.reserveCapacity(xs.foldRight(0) { c, n in
    if c {
      return n + 1
    } else {
      return n
    }
  })
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
  w.reserveCapacity(xs.map { $0.count }.foldRight(0, +))
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
