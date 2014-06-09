//
//  List.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

class Box<T> {
    let value : () -> T
    init(_ value : T) {
        self.value = { value }
    }
}

enum List<A> {
    case Nil
    case Cons(A, Box<List<A>>)

    init() {
        self = .Nil
    }
    init(_ head : A, _ tail : List<A>) {
        self = .Cons(head, Box(tail))
    }
    
    func safeHead() -> A? {
        switch self {
        case .Nil:
            return nil
        case let .Cons(head, _):
            return head
        }
    }
    
    func safeTail() -> List<A>? {
        switch self {
        case .Nil:
            return nil
        case let .Cons(_, tail):
            return tail.value()
        }
    }
}

func==<A : Equatable>(lhs : List<A>, rhs : List<A>) -> Bool {
    switch (lhs, rhs) {
    case (.Nil, .Nil):
        return true
    case let (.Cons(lHead, lTail), .Cons(rHead, rTail)):
        return lHead == rHead && lTail.value() == rTail.value()
    default:
        return false
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
            l = List(x, l)
        }
        return l
    }

    static func convertFromArrayLiteral(elements: A...) -> List<A> {
        return fromSeq(elements)
    }
}

extension List : Printable {
    var description : String {
    switch self {
    case .Nil:
        return "()"
    case let .Cons(head, tail):
        return "(\(head) . \(tail.value()))"
        }
    }
}

struct ListF<A, B> : Functor {
    let l : List<A>
    func fmap(fn : (A -> B)) -> List<B> {
        switch l {
        case .Nil:
           return List()
        case let .Cons(head, tail):
            return List(fn(head), ListF(l: tail.value()).fmap(fn))
        }
    }
}
