//
//  Chan.swift
//  swiftz
//
//  Created by Maxwell Swadling on 5/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

// An unbound FIFO channel.
// http://www.haskell.org/ghc/docs/latest/html/libraries/base/Control-Concurrent-Chan.html
public class Chan<A> {
  var stream: [A]
  
  var mutex: UnsafePointer<pthread_mutex_t>
  var cond: UnsafePointer<pthread_cond_t>
  let matt: UnsafePointer<pthread_mutexattr_t>
  
  public init() {
    var mattr:UnsafePointer<pthread_mutexattr_t> = UnsafePointer.alloc(sizeof(pthread_mutexattr_t))
    mutex = UnsafePointer.alloc(sizeof(pthread_mutex_t))
    cond = UnsafePointer.alloc(sizeof(pthread_cond_t))
    pthread_mutexattr_init(mattr)
    pthread_mutexattr_settype(mattr, PTHREAD_MUTEX_RECURSIVE)
    matt = UnsafePointer(mattr)
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

public operator infix <- {}
@infix public func <-<A>(chan: Chan<A>, value: A) -> Void
{
    chan.write(value)
}

public operator prefix <- {}
@prefix public func <-<A>(chan: Chan<A>) -> A
{
    return chan.read()
}
