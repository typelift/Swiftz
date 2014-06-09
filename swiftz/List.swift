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

extension List : ArrayLiteralConvertible {
    static func fromSeq<S : Sequence where S.GeneratorType.Element == A>(s : S) -> List<A> {
        // For some reason, everything simpler seems to crash the compiler
        var xs : A[] = []
        var g = s.generate()
        while let x : A = g.next() {
            xs += x
        }
        var l = List()
        for x in xs.reverse() {
            l = List<A>(x, l)
        }
        return l
    }

    static func convertFromArrayLiteral(elements: A...) -> List<A> {
        return fromSeq(elements)
    }
}
