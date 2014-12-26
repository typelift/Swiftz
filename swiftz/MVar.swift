//
//  MVar.swift
//  swiftz
//
//  Created by Maxwell Swadling on 7/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Darwin

// Reading an MVar that is empty will block until it has something in it.
// Putting into an MVar will block if it has something in it, until someone reads from it.
// http://www.haskell.org/ghc/docs/latest/html/libraries/base/Control-Concurrent-MVar.html
public final class MVar<A> : K1<A> {
	var value: Optional<(() -> A)>

	var mutex: UnsafeMutablePointer<pthread_mutex_t>
	var condPut: UnsafeMutablePointer<pthread_cond_t>
	var condRead: UnsafeMutablePointer<pthread_cond_t>
	let matt: UnsafeMutablePointer<pthread_mutexattr_t>

	public override init() {

		var mattr:UnsafeMutablePointer<pthread_mutexattr_t> = UnsafeMutablePointer.alloc(sizeof(pthread_mutexattr_t))
		mutex = UnsafeMutablePointer.alloc(sizeof(pthread_mutex_t))
		condPut = UnsafeMutablePointer.alloc(sizeof(pthread_cond_t))
		condRead = UnsafeMutablePointer.alloc(sizeof(pthread_cond_t))
		pthread_mutexattr_init(mattr)
		pthread_mutexattr_settype(mattr, PTHREAD_MUTEX_RECURSIVE)
		matt = UnsafeMutablePointer(mattr)
		pthread_mutex_init(mutex, matt)
		pthread_cond_init(condPut, nil)
		pthread_cond_init(condRead, nil)
	}

	public convenience init(a: @autoclosure () -> A) {
		self.init()
		value = a
	}

	deinit {
		mutex.destroy()
		condPut.destroy()
		condRead.destroy()
		matt.destroy()
	}

	public func put(x: A) {
		pthread_mutex_lock(mutex)
		while (value != nil) {
			pthread_cond_wait(condRead, mutex)
		}
		self.value = { x }
		pthread_mutex_unlock(mutex)
		pthread_cond_signal(condPut)
	}

	public func take() -> A {
		pthread_mutex_lock(mutex)
		while (value) == nil {
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
	public func isEmpty() -> Bool {
		return (value == nil)
	}

}
