//
//  NonEmptyList.swift
//  swiftz
//
//  Created by Maxwell Swadling on 10/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Basis

public final class NonEmptyList<A> : K1<A> {
  let head: A
  let tail: List<A>
  init(_ a: A, _ t: List<A>) {
    head = a
    tail = t
  }
}

public func head<A>() -> Lens<NonEmptyList<A>, NonEmptyList<A>, A, A> {
  return Lens { nel in IxStore(nel.head) { NonEmptyList($0, nel.tail) } }
}

public func tail<A>() -> Lens<NonEmptyList<A>, NonEmptyList<A>, List<A>, List<A>> {
  return Lens { nel in IxStore(nel.tail) { NonEmptyList(nel.head, $0) } }
}

public func ==<A : Equatable>(lhs : NonEmptyList<A>, rhs : NonEmptyList<A>) -> Bool {
  return (lhs.head == rhs.head && lhs.tail == rhs.tail)
}

extension NonEmptyList : ArrayLiteralConvertible {
  class public func fromSeq<S : SequenceType where S.Generator.Element == A>(s : S) -> NonEmptyList<A> {
    // what compiler stage does this run in...?...
    var xs : [A] = []
    var g = s.generate()
    let h: A? = g.next()
    while let x : A = g.next() {
      xs.append(x)
    }
    var l : List<A> = null()
    for x in xs.reverse() {
      l = cons(x)(l)
    }
    return NonEmptyList(h!, l)
  }

  class public func convertFromArrayLiteral(elements: A...) -> NonEmptyList<A> {
    return fromSeq(elements)
  }
}

public final class NonEmptyListGenerator<A> : K1<A>, GeneratorType {
  var l: List<A>
  public func next() -> A? {
    switch l.destruct() {
    case .Nil:
      return nil
    case .Cons(let hd, let tl):
      self.l = tl
      return hd
    }
  }

  public init(_ l : NonEmptyList<A>) {
    self.l = cons(l.head)(l.tail)
  }
}

extension NonEmptyList : SequenceType {
  public func generate() -> NonEmptyListGenerator<A> {
    return NonEmptyListGenerator(self)
  }
}

extension NonEmptyList : Printable {
  public var description : String {
    let x = NonEmptyList.fmap({ "\($0)" })(NonEmptyList(self.head, self.tail))
      return "[\(x)]"
  }
}

extension NonEmptyList : Functor {
  typealias B = Any
  typealias FA = NonEmptyList<A>
  typealias FB = NonEmptyList<B>

  public class func fmap<B>(f : (A -> B)) -> NonEmptyList<A> -> NonEmptyList<B> {
    return { l in NonEmptyList<B>(f(l.head), List.fmap(f)(l.tail)) }
  }
}

public func <%><A, B>(f: A -> B, l : NonEmptyList<A>) -> NonEmptyList<B> {
  return NonEmptyList.fmap(f)(l)
}

public func <% <A, B>(x : A, l : NonEmptyList<B>) -> NonEmptyList<A> {
  return NonEmptyList.fmap(const(x))(l)
}
