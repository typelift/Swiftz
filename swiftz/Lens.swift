//
//  Lens.swift
//  swiftz
//
//  Created by Maxwell Swadling on 8/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

struct Lens<S, T, A, B> {
     let run: S -> (A, B -> T)

     init(_ run: S -> (A, B -> T)) {
          self.run = run
     }

     init(get: S -> A, set: (S, B) -> T) {
          self.init({ v in (get(v), { set(v, $0) }) })
     }

     init(get: S -> A, modify: (S, A -> B) -> T) {
          self.init(get: get, set: { v, x in modify(v, { _ in x }) })
     }

     func get(v: S) -> A {
          return run(v).0
     }

     func set(v: S, _ x: B) -> T {
          return (run(v).1)(x)
     }

     func modify(v: S, _ f: A -> B) -> T {
          let (x, g) = run(v)
          return g(f(x))
     }

     func zoom<X>(a: IxState<A, B, X>) -> IxState<S, T, X> {
          return IxState { s1 in
               let (s2, f) = self.run(s1)
               let (x, s3) = a.run(s2)
               return (x, f(s3))
          }
     }
}

func identity<S, T>() -> Lens<S, T, S, T> {
     return Lens { ($0, identity) }
}

func comp<S, T, I, J, A, B>(l1: Lens<S, T, I, J>)(l2: Lens<I, J, A, B>) -> Lens<S, T, A, B> {
     return Lens { v in
          let (k, f1) = l1.run(v)
          let (x, f2) = l2.run(k)
          return (x, { f1(f2($0)) })
     }
}
