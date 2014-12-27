//
//  MVar.swift
//  swiftz
//
//  Created by Maxwell Swadling on 7/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Darwin

/// A mutable reference with potentially blocking reads and writes.  An MVar is either empty or
/// contains a value.  If the MVar is currently full then any subsequent writes to the MVar will
/// block.  If the MVar is empty than any subsequent reads will block until the MVar is full.
///
/// MVars are often used as synchronization points in concurrent code.  A thread will often
/// advertise an MVar and spark a computation that depends on a value computed in another thread.
/// The first thread blocks waiting for the second to finish, then immediatly continues its work
/// once a value has been put into the MVar.
public final class MVar<A> : K1<A> {
	var value : Optional<(() -> A)>

	let mutex : UnsafeMutablePointer<pthread_mutex_t>
	let condPut : UnsafeMutablePointer<pthread_cond_t>
	let condRead : UnsafeMutablePointer<pthread_cond_t>
	let matt : UnsafeMutablePointer<pthread_mutexattr_t>

	public override init() {
		let mattr : UnsafeMutablePointer<pthread_mutexattr_t> = UnsafeMutablePointer.alloc(sizeof(pthread_mutexattr_t))
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

	/// Puts a value into an MVar.
	///
	/// If the MVar is currently full, the function will block until it becomes empty again.
	public func put(x: A) {
		pthread_mutex_lock(mutex)
		while (value != nil) {
			pthread_cond_wait(condRead, mutex)
		}
		self.value = { x }
		pthread_mutex_unlock(mutex)
		pthread_cond_signal(condPut)
	}

	/// Returns the contents of the MVar.
	///
	/// If the MVar is empty, this will block until a value is put into the MVar.  If the MVar is full,
	/// it is emptied and the value is returned immediately.
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

	/// Checks whether a given MVar is empty.
	///
	/// This function is just a snapshot of the state of the MVar at that point in time.  In heavily
	/// concurrent computations, this may change out from under you without warning, or even by the 
	/// time it can be acted on.
	public func isEmpty() -> Bool {
		return (value == nil)
	}

}
