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
class Chan<A> {
  var stream: Array<A>
  
  var mutex: CMutablePointer<pthread_mutex_t>
  var cond: CMutablePointer<pthread_cond_t>
  let matt: CConstPointer<pthread_mutexattr_t>
  
  init() {
    var mattr:CMutablePointer<pthread_mutexattr_t> = CMutablePointer(owner: nil, value: malloc(UInt(sizeof(pthread_mutexattr_t))).value)
    // TODO: is owner nil ok? is malloc leaking?
    mutex = CMutablePointer(owner: nil, value: malloc(UInt(sizeof(pthread_mutex_t))).value)
    cond = CMutablePointer(owner: nil, value: malloc(UInt(sizeof(pthread_cond_t))).value)
    pthread_mutexattr_init(mattr)
    pthread_mutexattr_settype(mattr, PTHREAD_MUTEX_RECURSIVE)
    matt = CConstPointer(nil, mattr.value)
    pthread_mutex_init(mutex, matt)
    pthread_cond_init(cond, nil)
    stream = []
  }
  
  deinit {
    free(CMutableVoidPointer(owner: nil, value: mutex.value))
    free(CMutableVoidPointer(owner: nil, value: cond.value))
    free(CMutableVoidPointer(owner: nil, value: matt.value))
  }
  
  func write(a: A) {
    pthread_mutex_lock(mutex)
    stream.append(a)
    pthread_mutex_unlock(mutex)
    pthread_cond_signal(cond)
  }
  
  func read() -> A {
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
