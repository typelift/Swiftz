//
//  List.swift
//  swiftz_core
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

/// A recursive List, with the same basic usage as Array.
/// This is not currently possible with a bit of misdirection, hence the Box class.
public enum List<A> {
  case Nil
  case Cons(A, Box<List<A>>)

  public init() {
    self = .Nil
  }

  public init(_ head : A, _ tail : List<A>) {
    self = .Cons(head, Box(tail))
  }
  /// Appends and element onto the front of a list.
  static public func cons(h: A) -> List<A> -> List<A> {
    return { t in List(h, t) }
  }
  
  /// Returns the first element in the list, or None, if the list is empty.
  public func head() -> A? {
    switch self {
    case .Nil:
      return .None
    case let .Cons(head, _):
      return head
    }
  }

  /// Returns the tail of the list, or None if the list is Empty.
  public func tail() -> List<A>? {
    switch self {
    case .Nil:
      return .None
    case let .Cons(_, tail):
      return tail.value
    }
  }

  /// Returns the length of the list.
  public func length() -> Int {
    switch self {
    case .Nil: return 0
    case let .Cons(_, xs): return 1 + xs.value.length()
    }
  }

  /// Equivalent to the `reduce` function on normal arrays.
  public func foldl<B>(f: B -> A -> B, initial: B) -> B {
    var xs = initial
    for x in self {
      xs = f(xs)(x)
    }
    return xs
  }
  
  /// Reverse the list
  public func reverse() -> List<A> {
    return self.foldl(flip(List.cons), initial: List())
  }
  
  /// Given a predicate, searches the list until it find the first match, and returns that,
  /// or None if no match was found.
  public func find(pred: A -> Bool) -> A? {
    for x in self {
      if pred(x) {
        return x
      }
    }
    return nil
  }
  
  /// For an associated list, such as [(1,"one"),(2,"two")], takes a function(pass the identity function)
  /// and a key and returns the value for the given key, if there is one, or None otherwise.
  public func lookup<K: Equatable, V>(ev: A -> (K, V), key: K) -> V? {
    let pred: (K, V) -> Bool = { (k, _) in k == key }
    let val: (K, V) -> V = { (_, v) in v }
    return (({ val(ev($0)) }) <^> self.find({ pred(ev($0)) }))
  }
}

public func ==<A : Equatable>(lhs : List<A>, rhs : List<A>) -> Bool {
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
  typealias Element = A

  public init(arrayLiteral s: Element...) {
    var xs : [A] = []
    var g = s.generate()
    while let x : A = g.next() {
      xs.append(x)
    }
    var l = List()
    for x in xs.reverse() {
      l = List(x, l)
    }
    self = l
  }
}


public class ListGenerator<A> : GeneratorType {
  var l : Box<List<A>?>
  public func next() -> A? {
    var r = l.value?.head()
    l = Box(self.l.value?.tail())
    return r
  }
  public init(_ l : List<A>) {
    self.l = Box(l)
  }
}

extension List : SequenceType {
  public func generate() -> ListGenerator<A> {
    return ListGenerator(self)
  }
}

extension List : Printable {
  public var description : String {
    var x = ", ".join(ListF(l: self).fmap({ "\($0)" }))
      return "[\(x)]"
  }
}

/// A struct that serves as a Functor for the above List data type.
/// This is necessary since we don't yet have higher kinded types.
public struct ListF<A, B> : Functor {
  public let l : List<A>

  public init(l: List<A>) {
    self.l = l
  }

  // is recursion ok here?
  public func fmap(f : (A -> B)) -> List<B> {
    switch l {
    case .Nil:
      return List()
    case let .Cons(head, tail):
      return List(f(head), ListF(l: tail.value).fmap(f))
    }
  }
}
