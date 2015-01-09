//
//  GCDExecutionContext.swift
//  swiftz
//
//  Created by Maxwell Swadling on 4/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Dispatch

public let gcdExecutionContext = GCDExecutionContext()
public let gcdDispatchQueueGlobal = dispatch_queue_create("com.typelift.swiftz.globalExecutionContextQueue", DISPATCH_QUEUE_CONCURRENT)

public struct GCDExecutionContext : ExecutionContext {
	public func submit<A>(x: Future<A>, work: () -> A) {
		dispatch_async(gcdDispatchQueueGlobal, { x.sig(work()) })
	}
}
