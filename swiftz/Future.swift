//
//  Future.swift
//  swiftz
//
//  Created by Maxwell Swadling on 4/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

protocol ExecutionContext {
  func submit<A>(x: A -> (), y: () -> A)
}

class Future<A> {
  var value: (() -> A)?
  var lock: pthread_mutex_t
  var cond: pthread_cond_t
  let execCtx: ExecutionContext // for map
  
  init(exec: ExecutionContext, a: () -> A) {
    var mattr:pthread_mutexattr_t = pthread_mutexattr_t(__sig: 0, __opaque: (0, 0, 0, 0, 0, 0, 0, 0))
    lock = pthread_mutex_t(__sig: 0, __opaque: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
    cond = pthread_cond_t(__sig: 0, __opaque: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
    pthread_mutexattr_init(&mattr)
    pthread_mutexattr_settype(&mattr, PTHREAD_MUTEX_DEFAULT)
    pthread_mutex_init(&lock, &mattr)
    pthread_cond_init(&cond, nil)
    execCtx = exec
    exec.submit({ (x: A) -> () in self.sig(x) }, a)
  }
  
  func sig(x: A) {
    pthread_mutex_lock(&lock)
    self.value = { return x }
    pthread_cond_signal(&cond)
    pthread_mutex_unlock(&lock)
  }
  
  func result() -> A {
    pthread_mutex_lock(&lock)
    if !(value?) {
      pthread_cond_wait(&cond, &lock)
    }
    pthread_mutex_unlock(&lock)
    return value!()
  }
  
  func map<B>(f: A -> B) -> Future<B> {
    return Future<B>(exec: execCtx, { f(self.result()) })
  }
  
  func flatMap<B>(f: A -> Future<B>) -> Future<B> {
    return Future<B>(exec: execCtx, { f(self.result()).result() })
  }
}
