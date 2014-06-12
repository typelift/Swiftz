//
//  NonEmptyList.swift
//  swiftz
//
//  Created by Maxwell Swadling on 10/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

struct NonEmptyList<A> {
  let head: Box<A>

//  static let head: Lens<NonEmptyList<A>, NonEmptyList<A>, Box<A>, Box<A>> =
//    Lens { nel in (nel.head, { NonEmptyList($0, nel.tail) }) }

  let tail: List<A>

//  static let tail: Lens<NonEmptyList<A>, NonEmptyList<A>, List<A>, List<A>> =
//    Lens { nel in (nel.tail, { NonEmptyList(nel.head, $0) }) }

  init(_ a: A, _ t: List<A>) {
    head = Box(a)
    tail = t
  }
}

func==<A : Equatable>(lhs : NonEmptyList<A>, rhs : NonEmptyList<A>) -> Bool {
  return (lhs.head.value() == rhs.head.value() && lhs.tail == rhs.tail)
}

extension NonEmptyList : ArrayLiteralConvertible {
  static func fromSeq<S : Sequence where S.GeneratorType.Element == A>(s : S) -> NonEmptyList<A> {
    // what compiler stage does this run in...?...
    var xs : A[] = []
    var g = s.generate()
    let h: A? = g.next()
    while let x : A = g.next() {
      xs += x
    }
    var l = List<A>()
    for x in xs.reverse() {
      l = List(x, l)
    }
    return NonEmptyList(h!, l)
  }
  
  static func convertFromArrayLiteral(elements: A...) -> NonEmptyList<A> {
    return fromSeq(elements)
  }
}

class NonEmptyListGenerator<A> : Generator {
  var head: Box<A?>
  var l: Box<List<A>?>
  func next() -> A? {
    if let h = head.value() {
      head = Box(nil)
      return h
    } else {
      var r = l.value()?.head()
      l = Box(self.l.value()?.tail())
      return r
    }
  }
  init(_ l : NonEmptyList<A>) {
    head = Box(l.head.value())
    self.l = Box(l.tail)
  }
}

extension NonEmptyList : Sequence {
  func generate() -> NonEmptyListGenerator<A> {
    return NonEmptyListGenerator(self)
  }
}

extension NonEmptyList : Printable {
  var description : String {
  var x = ", ".join(NonEmptyListF(l: self).fmap({ "\($0)" }))
    return "[\(x)]"
  }
}

struct NonEmptyListF<A, B> : Functor {
  let l : NonEmptyList<A>
  func fmap(fn : (A -> B)) -> NonEmptyList<B> {
    return NonEmptyList(fn(l.head.value()), ListF(l: l.tail).fmap(fn))
  }
}
