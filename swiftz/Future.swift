//
//  Future.swift
//  swiftz
//
//  Created by Maxwell Swadling on 4/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Dispatch

/// Represents a value that has yet to be computed.  Futures are always paired with an
/// ExecutionContext that dictates where and how work is done.
///
/// The results of the computation that is performed when a Future is forced occur on a private 
/// background thread, but are delivered through the calling thread via a blocking operation.
public final class Future<A> : K1<A> {
	var value: A?

	// The resultQueue is used to read the result. It begins suspended
	// and is resumed once a result exists.
	// FIXME: Would like to add a uniqueid to the label
	let resultQueue = dispatch_queue_create("com.typelift.swift.future.resultQueue", DISPATCH_QUEUE_CONCURRENT)

	let execCtx: ExecutionContext // for map
	public init(exec: ExecutionContext) {
		dispatch_suspend(self.resultQueue)
		execCtx = exec
	}

	public init(exec: ExecutionContext, _ a: () -> A) {
		execCtx = exec
		super.init()
		dispatch_suspend(self.resultQueue)
		exec.submit(self, work: a)
	}

	public init(exec: ExecutionContext, _ a: @autoclosure () -> A) {
		execCtx = exec
		super.init()
		dispatch_suspend(self.resultQueue)
		exec.submit(self, work: a)
	}

	/// Forces a value to be computed 
	public func result() -> A {
		var result : A? = nil
		dispatch_sync(resultQueue, {
			result = self.value!
		})
		return result!
	}

	internal func sig(x: A) {
		assert(self.value == nil, "Future cannot complete more than once")
		self.value = x
		dispatch_resume(self.resultQueue)
	}

	/// Returns a future that maps the results of the receiver through a function in the same
	/// execution context.
	public func map<B>(f: A -> B) -> Future<B> {
		return Future<B>(exec: execCtx, { f(self.result()) })
	}

	public func flatMap<B>(f: A -> Future<B>) -> Future<B> {
		return Future<B>(exec: execCtx, { f(self.result()).result() })
	}
}
