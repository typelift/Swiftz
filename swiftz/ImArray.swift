//
//  ImArray.swift
//  swiftz
//
//  Created by Terry Lewis II on 6/9/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation
import swiftz_core

struct ImArray<A> : Sequence {
    let backing:[A] = Array()
    
    var array:[A] {
    return Array(backing)
    }
    
    subscript(index:Int) -> A {
        return backing[index]
    }
    
    subscript(subRange:Range<Int>) -> ImArray<A> {
        return ImArray(array: Array(backing[subRange]))
    }
    
    var count:Int {
    return backing.count
    }
    
    var isEmpty:Bool {
    return backing.isEmpty
    }
    
    init() {}
    
    init(items:A...) {
        backing = Array(items)
    }
    
    init(array:[A]) {
        backing = Array(array)
    }
    
    init(item:A) {
        backing = Array([item])
    }
    
    func append(item:A) -> ImArray<A> {
        var arr = Array(backing)
        arr += item
        return ImArray(array: arr)
    }
    
    func join(array:[A]) -> ImArray<A> {
        switch array {
        case []: return self
        case _: var newArr = Array(backing)
        for x in array {
            newArr += x
        }
        return ImArray(array: newArr)
        }
    }
    
    func join(imArray:ImArray<A>) -> ImArray<A> {
        if imArray.isEmpty {
            return self
        } else {
            var newArr = Array(backing)
            for x in imArray {
                newArr += x
            }
            return ImArray(array: newArr)
        }
    }
    
    func filter(f:(A -> Bool)) -> ImArray<A> {
        return ImArray(array: backing.filter(f))
    }
    
    func map<B>(f:(A -> B)) -> ImArray<B> {
        return ImArray<B>(array: backing.map(f))
    }
    
    func reduce<U>(start:U, f:((U,A) -> U)) -> U {
        return backing.reduce(start, combine: f)
    }
    
    
    func sort(f:(A,A) -> Bool) -> ImArray<A> {
        var newArr = Array(backing)
        newArr.sort(f)
        return ImArray(array: newArr)
    }
    
    func generate() -> ImArrayGenerator<A>  {
        let items = Array(backing)
        return ImArrayGenerator(items: items[0..items.count])
    }
}

struct ImArrayGenerator<A> : Generator {
    mutating func next() -> A?  {
        if items.isEmpty { return nil }
        let ret = items[0]
        items = items[1..items.count]
        return ret
    }
    
    var items:Slice<A>
}

extension ImArray : ArrayLiteralConvertible {
    static func convertFromArrayLiteral(elements: A...) -> ImArray<A> {
        return ImArray(array:elements)
    }
}

extension ImArray {
    func scanl<B>(start:B, r:(B, A) -> B) -> ImArray<B> {
        if self.isEmpty {
            return ImArray<B>(array: [])
        }
        var arr = B[]()
        arr += start
        var reduced = start
        for x in self {
            reduced = r(reduced, x)
            arr += reduced
        }
        return ImArray<B>(array: arr)
    }
    
    //tuples can not be compared with '==' so I will hold off on this for now. rdar://17219478
    //    func zip<B>(scd:ImArray<B>) -> ImArray<(A,B)> {
    //        var size = min(self.count, scd.count)
    //        var newArr = (A,B)[]()
    //        for x in 0..size {
    //            newArr += (self[x], scd[x])
    //        }
    //        return ImArray<(A,B)>(array:newArr)
    //    }
    //
    //    func zip3<B,C>(scd:ImArray<B>, thrd:ImArray<C>) -> ImArray<(A,B,C)> {
    //        var size = min(self.count, scd.count, thrd.count)
    //        var newArr = (A,B,C)[]()
    //        for x in 0..size {
    //            newArr += (self[x], scd[x], thrd[x])
    //        }
    //        return ImArray<(A,B,C)>(array:newArr)
    //    }
    //
    //    func zipWith<B,C>(scd:B[], f:((A, B) -> C)) -> ImArray<C> {
    //        var size = min(self.count, scd.count)
    //        var newArr = C[]()
    //        for x in 0..size {
    //            newArr += f(self[x], scd[x])
    //        }
    //        return ImArray<C>(array:newArr)
    //    }
    //
    //    func zipWith3<B,C,D>(scd:B[], thrd:C[], f:((A, B, C) -> D)) -> ImArray<D> {
    //        var size = min(self.count, scd.count, thrd.count)
    //        var newArr = D[]()
    //        for x in 0..size {
    //            newArr += f(self[x], scd[x], thrd[x])
    //        }
    //        return ImArray<D>(array:newArr)
    //    }
    
    func find(f:(A -> Bool)) -> A? {
        for x in self {
            if f(x) {
                return .Some(x)
            }
        }
        return .None
    }
    
    func splitAt(index:Int) -> (ImArray<A>, ImArray<A>) {
        switch index {
        case 0..self.count: return (ImArray(array:self[0..index].array), ImArray(array:self[index..self.count].array))
        case _:return (ImArray<A>(), ImArray<A>())
        }
    }
    
    func intersperse(item:A) -> ImArray<A> {
        func prependAll(item:A, array:[A]) -> [A] {
            var arr = Array([item])
            for i in 0..(array.count - 1) {
                arr += array[i]
                arr += item
            }
            arr += array[array.count - 1]
            return arr
        }
        if self.isEmpty {
            return self
        } else if self.count == 1 {
            return self
        } else {
            var array = Array([self[0]])
            array += prependAll(item, Array(self[1..self.count]))
            return ImArray(array:array)
        }
        
    }
}

func ==<A:Equatable>(lhs:ImArray<A>, rhs:ImArray<A>) -> Bool {
    return lhs.array == rhs.array
}

func !=<A:Equatable>(lhs:ImArray<A>, rhs:ImArray<A>) -> Bool {
    return !(lhs.array == rhs.array)
}

func +=<A>(lhs:ImArray<A>, rhs:A) -> ImArray<A> {
    return lhs.append(rhs)
}

// ImArray 'functions'

func pure<A>(a:A) -> ImArray<A> {
  return ImArray(item:a)
}

func<^><A, B>(f:A -> B, a:ImArray<A>) -> ImArray<B> {
  return a.map(f)
}

func <*><A, B>(f:ImArray<A -> B>, a:ImArray<A>) -> ImArray<B> {
  var re = B[]()
  for g in f {
    for h in a {
      re.append(g(h))
    }
  }
  return ImArray(array:re)
}

func >>=<A, B>(a: ImArray<A>, f: A -> ImArray<B>) -> ImArray<B> {
  var re = B[]()
  for x in a {
    re.extend(f(x))
  }
  return ImArray(array:re)
}

func sort<A:Comparable>(a:ImArray<A>) -> ImArray<A> {
    return ImArray(array: sort(a.backing.copy()))
}

func sort<A>(a:ImArray<A>, pred: (A,A) -> Bool) -> ImArray<A> {
    return ImArray(array: sort(a.backing.copy(), pred))
}
