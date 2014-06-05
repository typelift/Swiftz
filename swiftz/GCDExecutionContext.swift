//
//  GCDExecutionContext.swift
//  swiftz
//
//  Created by Maxwell Swadling on 4/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

let gcdExecutionContext = GCDExecutionContext()
let gcdDispatchQueueGlobal = dispatch_queue_create("swiftz.global", DISPATCH_QUEUE_CONCURRENT)

class GCDExecutionContext: ExecutionContext {
  func submit<A>(x: Future<A>, work: () -> A) {
    dispatch_async(gcdDispatchQueueGlobal, { x.sig(work()) })
  }
}
