//
//  List.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

/* @virtual */ class List<A> {
    
}

class Nil<A>: List<A> {
    
}

class Cons<A>: List<A> {
    typealias T = A
    let head: A
    let tail: List<A>
    init(h: A, t: List<A>) {
        head = h
        tail = t
    }
}
