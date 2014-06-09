//
//  List.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

enum List<A> {
    case Nil()
    case Cons(A, OnHeap<List<A>>)
    
    init() {
        self = .Nil()
    }
    init(_ head : A, _ tail : List<A>) {
        self = .Cons(head, OnHeap(tail))
    }
}
