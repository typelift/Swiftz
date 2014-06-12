//
//  IxState.swift
//  swiftz
//
//  Created by Alexander Ronald Altman on 6/11/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

struct IxState<I, O, A> {
     let run: I -> (A, O)

     init(_ run: I -> (A, O)) {
          self.run = run
     }

     func eval(s: I) -> A {
          return run(s).0
     }

     func exec(s: I) -> O {
          return run(s).1
     }

     func map<B>(f: A -> B) -> IxState<I, O, B> {
          return f <^> self
     }

     func contramap<H>(f: H -> I) -> IxState<H, O, A> {
          return f <!> self
     }

     func imap<P>(f: O -> P) -> IxState<I, P, A> {
          return f <^^> self
     }

//     func ap<E, B>(f: IxState<E, I, A -> B>) -> IxState<E, O, B> {
//          return f <*> self
//     }

     func flatMap<E, B>(f: A -> IxState<O, E, B>) -> IxState<I, E, B> {
          return self >>= f
     }
}

func pure<I, A>(x: A) -> IxState<I, I, A> {
     return IxState { (x, $0) }
}

func <^><I, O, A, B>(f: A -> B, a: IxState<I, O, A>) -> IxState<I, O, B> {
     return IxState { s1 in
          let (x, s2) = a.run(s1)
          return (f(x), s2)
     }
}

func <!><H, I, O, A>(f: H -> I, a: IxState<I, O, A>) -> IxState<H, O, A> {
     return IxState { a.run(f($0)) }
}

func <^^><I, O, P, A>(f: O -> P, a: IxState<I, O, A>) -> IxState<I, P, A> {
     return IxState { s1 in
          let (x, s2) = a.run(s1)
          return (x, f(s2))
     }
}

//func <*><I, J, O, A, B>(f: IxState<I, J, A -> B>, a: IxState<J, O, A>) -> IxState<I, O, B> {
//     return IxState { s1 in
//          let (g, s2) = f.run(s1)
//          let (x, s3) = a.run(s2)
//          return (g(x), s3)
//     }
//}

func >>=<I, J, O, A, B>(a: IxState<I, J, A>, f: A -> IxState<J, O, B>) -> IxState<I, O, B> {
     return IxState { s1 in
          let (x, s2) = a.run(s1)
          return f(x).run(s2)
     }
}

func join<I, J, O, A>(a: IxState<I, J, IxState<J, O, A>>) -> IxState<I, O, A> {
     return IxState { s1 in
          let (b, s2) = a.run(s1)
          return b.run(s2)
     }
}

func get<I>() -> IxState<I, I, I> {
     return IxState { ($0, $0) }
}

func gets<I, A>(f: I -> A) -> IxState<I, I, A> {
     return IxState { (f($0), $0) }
}

func put<I, O>(s: O) -> IxState<I, O, ()> {
     return IxState { _ in ((), s) }
}

func modify<I, O>(f: I -> O) -> IxState<I, O, ()> {
     return IxState { ((), f($0)) }
}
