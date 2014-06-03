//
//  Array.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

class ArrayZ<T>: Functor {
    typealias A = T
    typealias B = A
    typealias FA = ArrayZ<A>
    typealias FB = ArrayZ<A>
    
    let c : Array<A>
    
    init(a: Array<A>) {
        c = a
    }
    
    func map(f: A -> B) -> FA -> FB {
        return { (fa: FA) -> FB in
            return fa.c.map(f)
        }}
}
