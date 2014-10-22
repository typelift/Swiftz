//
//  Chan.swift
//  swiftz
//
//  Created by Maxwell Swadling on 5/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation
import swiftz_core

// An unbound FIFO channel.
// http://www.haskell.org/ghc/docs/latest/html/libraries/base/Control-Concurrent-Chan.html
public final class Chan<A> : K1<A> {
  var stream: [A]

  var mutex: UnsafeMutablePointer<pthread_mutex_t> = nil
  var cond: UnsafeMutablePointer<pthread_cond_t> = nil
  let matt: UnsafeMutablePointer<pthread_mutexattr_t> = nil

  public override init() {
    self.stream = []
    super.init()
    var mattr:UnsafeMutablePointer<pthread_mutexattr_t> = UnsafeMutablePointer.alloc(sizeof(pthread_mutexattr_t))
    mutex = UnsafeMutablePointer.alloc(sizeof(pthread_mutex_t))
    cond = UnsafeMutablePointer.alloc(sizeof(pthread_cond_t))
    pthread_mutexattr_init(mattr)
    pthread_mutexattr_settype(mattr, PTHREAD_MUTEX_RECURSIVE)
    matt = UnsafeMutablePointer(mattr)
    pthread_mutex_init(mutex, matt)
    pthread_cond_init(cond, nil)
    stream = []
  }

  deinit {
    mutex.destroy()
    cond.destroy()
    matt.destroy()
  }

  public func write(a: A) {
    pthread_mutex_lock(mutex)
    stream.append(a)
    pthread_mutex_unlock(mutex)
    pthread_cond_signal(cond)
  }

  public func read() -> A {
    pthread_mutex_lock(mutex)
    while (stream.isEmpty) {
      pthread_cond_wait(cond, mutex)
    }
    let v = stream[0]
    stream.removeAtIndex(0)
    pthread_mutex_unlock(mutex)
    return v
  }

}

infix operator  <- {}
public func <-<A>(chan: Chan<A>, value: A) -> Void
{
  chan.write(value)
}

prefix operator <- {}
public prefix func <-<A>(chan: Chan<A>) -> A
{
  return chan.read()
}
