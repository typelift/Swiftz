//
//  MVar.swift
//  swiftz
//
//  Created by Maxwell Swadling on 7/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

// Reading an MVar that is empty will block until it has something in it.
// Putting into an MVar will block if it has something in it, until someone reads from it.
// http://www.haskell.org/ghc/docs/latest/html/libraries/base/Control-Concurrent-MVar.html
class MVar<A> {
  var value: Optional<(() -> A)>
  
  var mutex: CMutablePointer<pthread_mutex_t>
  var condPut: CMutablePointer<pthread_cond_t>
  var condRead: CMutablePointer<pthread_cond_t>
  let matt: CConstPointer<pthread_mutexattr_t>
  
  init() {
    var mattr:CMutablePointer<pthread_mutexattr_t> = UnsafePointer.alloc(sizeof(pthread_mutexattr_t))
    mutex = UnsafePointer.alloc(sizeof(pthread_mutex_t))
    condPut = UnsafePointer.alloc(sizeof(pthread_cond_t))
    condRead = UnsafePointer.alloc(sizeof(pthread_cond_t))
    pthread_mutexattr_init(mattr)
    pthread_mutexattr_settype(mattr, PTHREAD_MUTEX_RECURSIVE)
    matt = CConstPointer(nil, mattr.value)
    pthread_mutex_init(mutex, matt)
    pthread_cond_init(condPut, nil)
    pthread_cond_init(condRead, nil)
  }
  
  convenience init(a: () -> A) {
    self.init()
    value = a
  }
  
  deinit {
    UnsafePointer(mutex).destroy()
    UnsafePointer(condPut).destroy()
    UnsafePointer(condRead).destroy()
    UnsafePointer(matt).destroy()
  }
  
  func put(x: A) {pthread_mutex_lock(mutex)
    while (value) {
      pthread_cond_wait(condRead, mutex)
    }
    self.value = { x }
    pthread_mutex_unlock(mutex)
    pthread_cond_signal(condPut)
  }
  
  func take() -> A {
    pthread_mutex_lock(mutex)
    while !(value) {
      pthread_cond_wait(condPut, mutex)
    }
    let cp = value!()
    value = .None
    pthread_mutex_unlock(mutex)
    pthread_cond_signal(condRead)
    return cp
  }
  
  // this isn't very useful! it is just a snapshot at this point in time.
  // you could check it is empty, then put, and it could block.
  // it is mostly for debugging and testing.
  func isEmpty() -> Bool {
    return !value.getLogicValue()
  }

}
