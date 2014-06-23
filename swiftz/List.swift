//
//  List.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

enum List<A> {
    case Nil
    case Cons(A, Box<List<A>>)

    init() {
        self = .Nil
    }
    init(_ head : A, _ tail : List<A>) {
        self = .Cons(head, Box(tail))
    }

    func head() -> A? {
        switch self {
        case .Nil:
            return nil
        case let .Cons(head, _):
            return head
        }
    }

    func tail() -> List<A>? {
        switch self {
        case .Nil:
            return nil
        case let .Cons(_, tail):
            return tail.value
        }
    }
  
    func length() -> Int {
        switch self {
            case .Nil: return 0
            case let .Cons(_, xs): return 1 + xs.value.length()
        }
    }

    func find(pred: A -> Bool) -> A? {
        for x in self {
            if pred(x) {
                return x
            }
        }
      return nil
    }

    func lookup<K: Equatable, V, EQ: TypeEquality where EQ.A == A, EQ.B == Tuple2<K, V>>(ev: EQ, key: K) -> V? {
      // this code exploits an implicit unsafe coerce
      func pred(t: Tuple2<K, V>) -> Bool {
        return t.a == key
      }
      func val(t: Tuple2<K, V>) -> V {
        return t.b
      }
      return (({ val(ev.apply($0)) }) <^> self.find({ pred(ev.apply($0)) }))
    }
}

func==<A : Equatable>(lhs : List<A>, rhs : List<A>) -> Bool {
    switch (lhs, rhs) {
    case (.Nil, .Nil):
        return true
    case let (.Cons(lHead, lTail), .Cons(rHead, rTail)):
        return lHead == rHead && lTail.value == rTail.value
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

class ListGenerator<A> : Generator {
    var l : Box<List<A>?>
    func next() -> A? {
        var r = l.value?.head()
        l = Box(self.l.value?.tail())
        return r
    }
    init(_ l : List<A>) {
        self.l = Box(l)
    }
}

extension List : Sequence {
    func generate() -> ListGenerator<A> {
        return ListGenerator(self)
    }
}

extension List : Printable {
    var description : String {
  var x = ", ".join(ListF(l: self).fmap({ "\($0)" }))
        return "[\(x)]"
    }
}

struct ListF<A, B> : Functor {
    let l : List<A>
    // TODO: is recursion ok here?
    func fmap(fn : (A -> B)) -> List<B> {
        switch l {
        case .Nil:
           return List()
        case let .Cons(head, tail):
            return List(fn(head), ListF(l: tail.value).fmap(fn))
        }
    }
}
