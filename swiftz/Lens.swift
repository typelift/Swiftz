//
//  Lens.swift
//  swiftz
//
//  Created by Maxwell Swadling on 8/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation
#if TARGET_OS_MAC
import swiftz_core
#else
import swiftz_core_ios
#endif


class Lens<S, T, A, B> {
     let run: S -> IxStore<A, B, T>

     init(_ run: S -> IxStore<A, B, T>) {
          self.run = run
     }

     convenience init(get: S -> A, set: (S, B) -> T) {
          self.init({ v in IxStore(get(v)) { set(v, $0) } })
     }

     convenience init(get: S -> A, modify: (S, A -> B) -> T) {
          self.init(get: get, set: { v, x in modify(v, { _ in x }) })
     }

     func get(v: S) -> A {
          return run(v).pos
     }

     func set(v: S, _ x: B) -> T {
          return run(v).peek(x)
     }

     func modify(v: S, _ f: A -> B) -> T {
          let q = run(v)
          return q.peek(f(q.pos))
     }

     func zoom<X>(a: IxState<A, B, X>) -> IxState<S, T, X> {
          return IxState { s1 in
               let q = self.run(s1)
               let (x, s2) = a.run(q.pos)
               return (x, q.peek(s2))
          }
     }
}

func identity<S, T>() -> Lens<S, T, S, T> {
     return Lens { IxStore($0, identity) }
}

func comp<S, T, I, J, A, B>(l1: Lens<S, T, I, J>)(l2: Lens<I, J, A, B>) -> Lens<S, T, A, B> {
     return Lens { v in
          let q1 = l1.run(v)
          let q2 = l2.run(q1.pos)
          return IxStore(q2.pos) { q1.peek(q2.peek($0)) }
     }
}

func •<S, T, I, J, A, B>(l1: Lens<S, T, I, J>, l2: Lens<I, J, A, B>) -> Lens<S, T, A, B> {
	return Lens { v in
		let q1 = l1.run(v)
		let q2 = l2.run(q1.pos)
		return IxStore(q2.pos) { q1.peek(q2.peek($0)) }
	}
}

// Box iso

func isoBox<A, B>() -> Lens<Box<A>, Box<B>, A, B> {
  return Lens { v in IxStore(v.value) { Box($0) } }
}

// Functor base types

func isoId<A, B>() -> Lens<Id<A>, Id<B>, A, B> {
  return Lens { v in IxStore(v.runId()) { Id($0) } }
}

func isoConst<A, B, X>() -> Lens<Const<A, X>, Const<B, X>, A, B> {
  return Lens { v in IxStore(v.runConst()) { Const($0) } }
}
