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
    
    public func scanl<B>(start:B, r:(B, T) -> B) -> [B] {
        if self.isEmpty {
            return []
        }
        var arr = [B]()
        arr += start
        var reduced = start
        for x in self {
            reduced = r(reduced, x)
            arr += reduced
        }
        return [B](arr)
    }
    
    public func find(f:(T -> Bool)) -> T? {
        for x in self {
            if f(x) {
                return .Some(x)
            }
        }
        return .None
    }
    
    public func splitAt(index:Int) -> ([T], [T]) {
        switch index {
        case 0..<self.count: return ([](self[0..<index]), [](self[index..<self.count]))
        case _:return ([T](), [T]())
        }
    }
    
    public func intersperse(item:T) -> [T] {
        func prependAll(item:T, array:[T]) -> [T] {
            var arr = []([item])
            for i in 0..<(array.count - 1) {
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
            var array = []([self[0]])
            array += prependAll(item, [](self[1..<self.count]))
            return [](array)
        }
    }
    
    //tuples can not be compared with '==' so I will hold off on this for now. rdar://17219478
    //    func zip<B>(scd:Im[B]) -> Array<(A,B)> {
    //        var size = min(self.count, scd.count)
    //        var newArr = (A,B)[]()
    //        for x in 0..size {
    //            newArr += (self[x], scd[x])
    //        }
    //        return Array<(A,B)>(newArr)
    //    }
    //
    //    func zip3<B,C>(scd:Im[B], thrd:Array<C>) -> Array<(A,B,C)> {
    //        var size = min(self.count, scd.count, thrd.count)
    //        var newArr = (A,B,C)[]()
    //        for x in 0..size {
    //            newArr += (self[x], scd[x], thrd[x])
    //        }
    //        return Array<(A,B,C)>(newArr)
    //    }
    //
    //    func zipWith<B,C>(scd:B[], f:((A, B) -> C)) -> Array<C> {
    //        var size = min(self.count, scd.count)
    //        var newArr = C[]()
    //        for x in 0..size {
    //            newArr += f(self[x], scd[x])
    //        }
    //        return Array<C>(newArr)
    //    }
    //
    //    func zipWith3<B,C,D>(scd:B[], thrd:C[], f:((A, B, C) -> D)) -> Array<D> {
    //        var size = min(self.count, scd.count, thrd.count)
    //        var newArr = D[]()
    //        for x in 0..size {
    //            newArr += f(self[x], scd[x], thrd[x])
    //        }
    //        return Array  <D>(newArr)
    //    }
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

