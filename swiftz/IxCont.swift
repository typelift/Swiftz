//
//  IxCont.swift
//  swiftz
//
//  Created by Alexander Ronald Altman on 6/10/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation
#if TARGET_OS_MAC
import swiftz_core
#else
import swiftz_core_ios
#endif

struct IxCont<R, O, A> {
  let run: (A -> O) -> R

  init(_ run: (A -> O) -> R) {
    self.run = run
  }

  func map<B>(f: A -> B) -> IxCont<R, O, B> {
    return f <^> self
  }

  func imap<S>(f: R -> S) -> IxCont<S, O, A> {
    return f <^^> self
  }

  func contramap<N>(f: N -> O) -> IxCont<R, N, A> {
    return f <!> self
  }

  func ap<E, B>(f: IxCont<E, R, A -> B>) -> IxCont<E, O, B> {
    return f <*> self
  }

  func flatMap<E, B>(f: A -> IxCont<O, E, B>) -> IxCont<R, E, B> {
    return self >>= f
  }
}

func run<R, O>(a: IxCont<R, O, O>) -> R {
  return a.run(identity)
}

func pure<R, A>(x: A) -> IxCont<R, R, A> {
  return IxCont { $0(x) }
}

func <^><R, O, A, B>(f: A -> B, a: IxCont<R, O, A>) -> IxCont<R, O, B> {
  return IxCont { k in a.run { k(f($0)) } }
}

func <^^><R, S, O, A>(f: R -> S, a: IxCont<R, O, A>) -> IxCont<S, O, A> {
  return IxCont { f(a.run($0)) }
}

func <!><R, N, O, A>(f: N -> O, a: IxCont<R, O, A>) -> IxCont<R, N, A> {
  return IxCont { k in a.run { f(k($0)) } }
}

func <*><R, I, O, A, B>(f: IxCont<R, I, A -> B>, a: IxCont<I, O, A>) -> IxCont<R, O, B> {
  return IxCont { k in f.run { g in a.run { k(g($0)) } } }
}

func >>=<R, I, O, A, B>(a: IxCont<R, I, A>, f: A -> IxCont<I, O, B>) -> IxCont<R, O, B> {
  return IxCont { k in a.run { f($0).run(k) } }
}

func join<R, I, O, A>(a: IxCont<R, I, IxCont<I, O, A>>) -> IxCont<R, O, A> {
  return IxCont { k in a.run { $0.run(k) } }
}

func shift<R, I, J, O, A>(f: (A -> IxCont<I, I, O>) -> IxCont<R, J, J>) -> IxCont<R, O, A> {
  return IxCont { k in run(f { pure(k($0)) }) }
}

func reset<R, O, A>(a: IxCont<A, O, O>) -> IxCont<R, R, A> {
  return pure(run(a))
}

func callCC<R, O, A, B>(f: (A -> IxCont<O, O, B>) -> IxCont<R, O, A>) -> IxCont<R, O, A> {
  return IxCont { k in (f { x in IxCont { _ in k(x) } }).run(k) }
}
