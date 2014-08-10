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
    
    public func join(array:[T]) -> [T] {
        if array.isEmpty {
            return self
        }
        else {
            var newArr = Array(self)
            newArr.extend(array)
            return newArr
        }
    }
}

public func scanl<B, T>(start:B, list:[T], r:(B, T) -> B) -> [B] {
    if list.isEmpty {
        return []
    }
    var arr = [B]()
    arr.append(start)
    var reduced = start
    for x in list {
        reduced = r(reduced, x)
        arr.append(reduced)
    }
    return Array(arr)
}


public func find<T>(list:[T], f:(T -> Bool)) -> T? {
    for x in list {
        if f(x) {
            return .Some(x)
        }
    }
    return .None
}



public func splitAt<T>(index:Int, list:[T]) -> ([T], [T]) {
    switch index {
    case 0..<list.count: return (Array(list[0..<index]), Array(list[index..<list.count]))
    case _:return ([T](), [T]())
    }
}

public func intersperse<T>(item:T, list:[T]) -> [T] {
    func prependAll(item:T, array:[T]) -> [T] {
        var arr = Array([item])
        for i in 0..<(array.count - 1) {
            arr.append(array[i])
            arr.append(item)
        }
        arr.append(array[array.count - 1])
        return arr
    }
    if list.isEmpty {
        return list
    } else if list.count == 1 {
        return list
    } else {
        var array = Array([list[0]])
        array += prependAll(item, Array(list[1..<list.count]))
        return Array(array)
    }
}

//tuples can not be compared with '==' so I will hold off on this for now. rdar://17219478
//public func zip<A,B>(fst:[A], scd:[B]) -> Array<(A,B)> {
//    var size = min(fst.count, scd.count)
//    var newArr = Array<(A,B)>()
//    for x in 0..<size {
//        newArr += (fst[x], scd[x])
//    }
//    return newArr
//}
//
//public func zip3<A,B,C>(fst:[A], scd:[B], thrd:[C]) -> Array<(A,B,C)> {
//    var size = min(fst.count, scd.count, thrd.count)
//    var newArr = Array<(A,B,C)>()
//    for x in 0..<size {
//        newArr += (fst[x], scd[x], thrd[x])
//    }
//    return newArr
//}
//
//public func zipWith<A,B,C>(fst:[A], scd:[B], f:((A, B) -> C)) -> Array<C> {
//    var size = min(fst.count, scd.count)
//    var newArr = [C]()
//    for x in 0..<size {
//        newArr += f(fst[x], scd[x])
//    }
//    return newArr
//}
//
//public func zipWith3<A,B,C,D>(fst:[A], scd:[B], thrd:[C], f:((A, B, C) -> D)) -> Array<D> {
//    var size = min(fst.count, scd.count, thrd.count)
//    var newArr = [D]()
//    for x in 0..<size {
//        newArr += f(fst[x], scd[x], thrd[x])
//    }
//    return newArr
//}


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

public func and(list:[Bool]) -> Bool {
    return list.reduce(true) {$0 && $1}
}
public func or(list:[Bool]) -> Bool {
    return list.reduce(false) {$0 || $1}
}

public func any<A>(list:[A], f:(A -> Bool)) -> Bool {
    return or(list.map(f))
}

public func all<A>(list:[A], f:(A -> Bool)) -> Bool {
    return and(list.map(f))
}

public func concat<A>(list:[[A]]) -> [A] {
    return list.reduce([]) {
        (var start, l) -> [A] in
        start += l
        return start
    }
}

public func concatMap<A,B>(list:[A], f:A -> [B]) -> [B] {
    return list.reduce([]) {
        (var start, l) -> [B] in
        start += f(l)
        return start
    }
}

public func intercalate<A>(list:[A], nested:[[A]]) -> [A] {
    return concat(intersperse(list, nested))
}

public func span<A>(list:[A], p: (A -> Bool)) -> ([A], [A]) {
    switch list.count {
    case 0: return (list, list)
    case 1...list.count where p(list.first!):
        let first = list.first!
        let (ys,zs) = span(Array(list[1..<list.count]), p)
        var f = [first]
        f += ys
        return (f,zs)
    default:  return ([], list)
    }
}

public func groupBy<A>(list:[A], p:(A -> A -> Bool)) -> [[A]] {
    switch list.count {
    case 0: return []
    case 1...list.count:
        let first = list.first!
        let (ys,zs) = span(Array(list[1..<list.count]), p(first))
        var x = [first]
        x += ys
        var nested = [x]
        nested += groupBy(zs, p)
        return nested
    default: return []
    }
}

public func group<A:Equatable>(list:[A]) -> [[A]] {
    return groupBy(list, {a in {b in a == b}})
}

public func dropWhile<A>(list:[A], p:A -> Bool) -> [A] {
    switch list.count {
    case 0: return list
    case 1...list.count where p(list.first!):
        return dropWhile(Array(list[1..<list.count]), p)
    default: return list
    }
}

public func takeWhile<A>(list:[A], p:A -> Bool) -> [A] {
    switch list.count {
    case 0: return list
    case 1...list.count where p(list.first!):
        var f = [list.first!]
        f += takeWhile(Array(list[1..<list.count]), p)
        return f
    default: return []
    }
}
