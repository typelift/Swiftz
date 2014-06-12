//
//  Set.swift
//  swiftz
//
//  Created by Terry Lewis II on 6/7/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

operator infix ∩ {}
operator infix ∪ {}

struct Set<A: Hashable> : Sequence {
    let bucket:Dictionary<A, Bool> = Dictionary()
    
    var array:Array<A> {
    var arr = Array<A>()
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
    
    init(array:Array<A>) {
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
        var array:A[] = Array()
        for x in self {
            if let memb = set.member(x) {
                array += memb
            }
        }
        return Set(array:array)
    }
    
    func minus(set:Set<A>) -> Set<A> {
        var array:A[] = Array()
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
        var array = Array<A>()
        for x in self {
            if f(x) {
                array += x
            }
        }
        return Set(array: array)
    }
    
    func map<B>(f:(A -> B)) -> Set<B> {
        var array:Array<B> = Array()
        for x in self {
            array += f(x)
        }
        
        return Set<B>(array: array)
    }
    
    func generate() -> SetGenerator<A>  {
        let items = self.array
        return SetGenerator(items: items[0..items.count])
    }
}


struct SetGenerator<A> : Generator {
    mutating func next() -> A?  {
        if items.isEmpty { return nil }
        let ret = items[0]
        items = items[1..items.count]
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

func ==<A: Equatable, B: Equatable>(lhs:Set<A>, rhs:Set<B>) -> Bool {
    return lhs.bucket == rhs.bucket
}

func !=<A: Equatable, B: Equatable>(lhs:Set<A>, rhs:Set<B>) -> Bool {
    return lhs.bucket != rhs.bucket
}

func +=<A>(set:Set<A>, item:A) -> Set<A> {
    if set.contains(item) {
        return set
    } else {
        var arr = set.array
        arr += item
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
