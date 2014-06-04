//
//  Chan.swift
//  swiftz
//
//  Created by Maxwell Swadling on 5/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//


class Chan<A> {
  var stream: Array<A>
  
  var lock: pthread_mutex_t
  var cond: pthread_cond_t
  
  init() {
    var mattr:pthread_mutexattr_t = pthread_mutexattr_t(__sig: 0, __opaque: (0, 0, 0, 0, 0, 0, 0, 0))
    lock = pthread_mutex_t(__sig: 0, __opaque: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
    cond = pthread_cond_t(__sig: 0, __opaque: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
    pthread_mutexattr_init(&mattr)
    pthread_mutexattr_settype(&mattr, PTHREAD_MUTEX_DEFAULT)
    pthread_mutex_init(&lock, &mattr)
    pthread_cond_init(&cond, nil)
    stream = []
  }
  
  func write(a: A) {
    pthread_mutex_lock(&lock)
    stream.append(a)
    pthread_cond_signal(&cond)
    pthread_mutex_unlock(&lock)
  }
  
  func read() -> A {
    pthread_mutex_lock(&lock)
    if (stream.isEmpty) {
      pthread_cond_wait(&cond, &lock)
    }
    let v = stream[0]
    stream.removeAtIndex(0)
    pthread_mutex_unlock(&lock)
    return v
  }
  
}
