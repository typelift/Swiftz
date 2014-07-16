//
//  Set.swift
//  swiftz
//
//  Created by Terry Lewis II on 6/7/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation
import swiftz_core

operator infix ∩ {}
operator infix ∪ {}

struct Set<A: Hashable> : Sequence {
    let bucket:Dictionary<A, Bool> = Dictionary()
    
    var array:[A] {
    var arr = [A]()
        for (key, _) in bucket {
            arr += key
        }
        return arr
        
    }
    
    var count:Int {
        return bucket.count
        
    }

    init() {
        // an empty set
    }

    init(items:A...) {
        for obj in items {
            bucket[obj] = true
        }
    }
    
    init(array:[A]) {
        for obj in array {
            bucket[obj] = true
        }
    }
    
  func any() -> A? {
      let ar = self.array
      if ar.isEmpty {
          return nil
      } else {
          let index = Int(arc4random_uniform(UInt32(ar.count)))
          return ar[index]
      }
    }
    
    func contains(item:A) -> Bool {
        if let c = bucket[item] {
            return c
        } else {
            return false
        }
    }
    
    func member(item:A) -> A? {
        if self.contains(item) {
            return .Some(item)
        } else {
            return nil
        }
    }
    
    func interectsSet(set:Set<A>) -> Bool {
        for x in set {
            if self.contains(x) {
                return true
            }
        }
        return false
    }
    
    func intersect(set:Set<A>) -> Set<A> {
        var array:[A] = Array()
        for x in self {
            if let memb = set.member(x) {
                array += memb
            }
        }
        return Set(array:array)
    }
    
    func minus(set:Set<A>) -> Set<A> {
        var array:[A] = Array()
        for x in self {
            if !set.contains(x) {
                array += x
            }
        }
        return Set(array:array)
    }
    
    func union(set:Set<A>) -> Set<A> {
        var current = self.array
        current += set.array
        return Set(array: current)
    }
    
    func add(item:A) -> Set<A> {
        if contains(item) {
            return self
        } else {
            var arr = array
            arr += item
            return Set(array:arr)
        }
    }
    
    func filter(f:(A -> Bool)) -> Set<A> {
        var array = [A]()
        for x in self {
            if f(x) {
                array += x
            }
        }
        return Set(array: array)
    }
    
    func map<B>(f:(A -> B)) -> Set<B> {
        var array:[B] = Array()
        for x in self {
            array += f(x)
        }
        
        return Set<B>(array: array)
    }
    
    func generate() -> SetGenerator<A>  {
        let items = self.array
        return SetGenerator(items: items[0..<items.count])
    }
}


struct SetGenerator<A> : Generator {
    mutating func next() -> A?  {
        if items.isEmpty { return nil }
        let ret = items[0]
        items = items[1..<items.count]
        return ret
    }
    
    var items:Slice<A>
    
}

extension Set : Printable,DebugPrintable {
    var description:String {
        return "\(self.array)"
    }
    
    var debugDescription:String {
        return "\(self.array)"
    }
}

extension Set : ArrayLiteralConvertible {
    static func convertFromArrayLiteral(elements: A...) -> Set<A> {
        return Set(array:elements)
    }
}

@infix func ==<A: Equatable, B: Equatable>(lhs:Set<A>, rhs:Set<B>) -> Bool {
    return lhs.bucket == rhs.bucket
}

@infix func !=<A: Equatable, B: Equatable>(lhs:Set<A>, rhs:Set<B>) -> Bool {
    return lhs.bucket != rhs.bucket
}

@infix func +=<A>(set:Set<A>, item:A) -> Set<A> {
    if set.contains(item) {
        return set
    } else {
        var arr = set.array
        arr += item
        return Set(array:arr)
    }
}

@infix func -<A>(lhs:Set<A>, rhs:Set<A>) -> Set<A> {
    return lhs.minus(rhs)
}

@infix func ∩<A>(lhs:Set<A>, rhs:Set<A>) -> Set<A> {
    return lhs.intersect(rhs)
}

@infix func ∪<A>(lhs:Set<A>, rhs:Set<A>) -> Set<A> {
    return lhs.union(rhs)
}

// Set 'functions'

func pure<A>(a:A) -> Set<A> {
  return Set(items: a)
}

@infix func <^><A, B>(f: A -> B, set:Set<A>) -> Set<B> {
  return set.map(f)
}

// Can't do applicative on a Set currently
//@infix func <*><A, B>(f:Set<A -> B>, a:Set<A>) -> Set<B> {
//
//    return Set<B>()
//}

@infix func >>=<A, B>(a:Set<A>, f: A -> Set<B>) -> Set<B> {
  var se = [B]()
  for x in a {
    se.extend(f(x))
  }
  return Set(array:se)
}
