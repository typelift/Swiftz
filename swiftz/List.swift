//
//  List.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

// Desired implementation:
// enum List<A> {
//  case Nil()
//  case Cons(T, List<A>)
// }

// Workaround implementation:
// Typechecks, but can not produce code.
///* @virtual */ class List<A> {
//  // empty
//}
//
//class Nil<A>: List<A> {
//  // empty
//}
//
//class Cons<A>: List<A> {
//  typealias T = A
//  let head: A
//  let tail: List<A>
//  init(h: A, t: List<A>) {
//    head = h
//    tail = t
//  }
//}
