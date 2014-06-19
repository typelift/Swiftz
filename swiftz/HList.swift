//
//  HList.swift
//  swiftz
//
//  Created by Maxwell Swadling on 19/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

/* closed */ protocol HList {
  typealias Head
  typealias Tail // : HList can't show Nothing is in HList, recursive defn.
  class func isNil() -> Bool
  class func makeNil() -> Self
  class func makeCons(h: Head, t: Tail) -> Self
}

@final class HCons<H, T: HList> : HList {
  typealias Head = H
  typealias Tail = T
  let head: Box<H>
  let tail: Box<T>
  init(h: H, t: T) {
    head = Box(h)
    tail = Box(t)
  }
  
  class func isNil() -> Bool {
    return false
  }
  class func makeNil() -> HCons<H, T> {
    abort() // impossible
  }
  class func makeCons(h: Head, t: Tail) -> HCons<H, T> {
    return HCons<H, T>(h: h, t: t)
  }
}

@final class HNil : HList {
  typealias Head = Nothing
  typealias Tail = Nothing
  
  init() {}
  class func isNil() -> Bool {
    return true
  }
  
  class func makeNil() -> HNil {
    return HNil()
  }
  
  class func makeCons(h: Head, t: Tail) -> HNil {
    abort() // impossible
  }
}

// A is in L
func map<A, B, C: HList, D: HList, L: HList, M: HList where L.Head == A, M.Head == B, L.Tail == C, M.Tail == D>(list: L, fn: A -> B) -> M {
  if L.isNil() {
    return M.makeNil()
  } else {
    let lst = list as HCons<A, C>
    let h = fn(lst.head.value)
    let tp: C = lst.tail.value
    let t: D = map(tp, fn)
    return M.makeCons(h, t: t)
  }
}

// A is not in L
func map<X, A, B, C: HList, D: HList, L: HList, M: HList where L.Head == X, M.Head == X, L.Tail == C, M.Tail == D>(list: L, fn: A -> B) -> M {
  if L.isNil() {
    return M.makeNil()
  } else {
    let lst = list as HCons<X, C>
    let h = lst.head.value
    let tp: C = lst.tail.value
    let t: D = map(tp, fn)
    return M.makeCons(h, t: t)
  }
}

func map<J, U, N: HList, K: HList>(a: N, fn: J -> U) -> K {
  abort() // impossible
}

// TODO: reverse
