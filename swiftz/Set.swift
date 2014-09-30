//
//  Set.swift
//  swiftz
//
//  Created by Terry Lewis II on 6/7/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation


infix operator ∩ {}
infix operator ∪ {}

public struct Set<A: Hashable> : SequenceType {
  let bucket:Dictionary<A, Bool> = Dictionary()

  var array:[A] {
    var arr = [A]()
      for (key, _) in bucket {
        arr.append(key)
      }
      return arr

  }

  public var count:Int {
    return bucket.count
  }

  public init() {
    // an empty set
  }

  public init(items:A...) {
    for obj in items {
      bucket[obj] = true
    }
  }

  public init(array:[A]) {
    for obj in array {
      bucket[obj] = true
    }
  }

  public func any() -> A? {
    let ar = self.array
    if ar.isEmpty {
      return nil
    } else {
      let index = Int(arc4random_uniform(UInt32(ar.count)))
      return ar[index]
    }
  }

  public func contains(item:A) -> Bool {
    if let c = bucket[item] {
      return c
    } else {
      return false
    }
  }

  public func containsAll(set:Set<A>) -> Bool {
    var count = 0
    for x in self {
      if let memb = set.member(x) {
        count++
      }
    }

    return self.count == count
  }

  public func member(item:A) -> A? {
    if self.contains(item) {
      return .Some(item)
    } else {
      return nil
    }
  }

  public func interectsSet(set:Set<A>) -> Bool {
    for x in set {
      if self.contains(x) {
        return true
      }
    }
    return false
  }

  public func intersect(set:Set<A>) -> Set<A> {
    var array:[A] = Array()
    for x in self {
      if let memb = set.member(x) {
        array.append(memb)
      }
    }
    return Set(array:array)
  }

  public func minus(set:Set<A>) -> Set<A> {
    var array:[A] = Array()
    for x in self {
      if !set.contains(x) {
        array.append(x)
      }
    }
    return Set(array:array)
  }

  public func union(set:Set<A>) -> Set<A> {
    var current = self.array
    current += set.array
    return Set(array: current)
  }

  public func add(item:A) -> Set<A> {
    if contains(item) {
      return self
    } else {
      var arr = array
      arr.append(item)
      return Set(array:arr)
    }
  }

  public func filter(f:(A -> Bool)) -> Set<A> {
    var array = [A]()
    for x in self {
      if f(x) {
        array.append(x)
      }
    }
    return Set(array: array)
  }

  public func map<B>(f:(A -> B)) -> Set<B> {
    var array:[B] = Array()
    for x in self {
      array.append(f(x))
    }

    return Set<B>(array: array)
  }

  public func generate() -> SetGenerator<A>  {
    let items = self.array
    return SetGenerator(items: items[0..<items.count])
  }
}


public struct SetGenerator<A> : GeneratorType {
  mutating public func next() -> A?  {
    if items.isEmpty { return nil }
    let ret = items[0]
    items = items[1..<items.count]
    return ret
  }

  var items:Slice<A>

}

extension Set : Printable,DebugPrintable {
  public var description: String {
    return "\(self.array)"
  }

  public var debugDescription: String {
    return "\(self.array)"
  }
}

extension Set : ArrayLiteralConvertible {
  static public func convertFromArrayLiteral(elements: A...) -> Set<A> {
    return Set(array:elements)
  }
}

public func ==<A: Equatable>(lhs:Set<A>, rhs:Set<A>) -> Bool {
  return lhs.containsAll(rhs) && rhs.containsAll(lhs)
}

public func !=<A: Equatable>(lhs:Set<A>, rhs:Set<A>) -> Bool {
  return !(lhs == rhs)
}

func +=<A>(set:Set<A>, item:A) -> Set<A> {
  if set.contains(item) {
    return set
  } else {
    var arr = set.array
    arr.append(item)
    return Set(array:arr)
  }
}

func -<A>(lhs:Set<A>, rhs:Set<A>) -> Set<A> {
  return lhs.minus(rhs)
}

func ∩<A>(lhs:Set<A>, rhs:Set<A>) -> Set<A> {
  return lhs.intersect(rhs)
}

func ∪<A>(lhs:Set<A>, rhs:Set<A>) -> Set<A> {
  return lhs.union(rhs)
}

// Set 'functions'

func pure<A>(a:A) -> Set<A> {
  return Set(items: a)
}

func <^><A, B>(f: A -> B, set:Set<A>) -> Set<B> {
  return set.map(f)
}

// Can't do applicative on a Set currently
// func <*><A, B>(f:Set<A -> B>, a:Set<A>) -> Set<B> {
//
//    return Set<B>()
//}

func >>-<A, B>(a:Set<A>, f: A -> Set<B>) -> Set<B> {
  var se = [B]()
  for x in a {
    se.extend(f(x))
  }
  return Set(array:se)
}
