//
//  Future.swift
//  swiftz
//
//  Created by Maxwell Swadling on 4/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation
import swiftz_core

public class Future<A> {
  var value: A?

  // The resultQueue is used to read the result. It begins suspended
  // and is resumed once a result exists.
  // FIXME: Would like to add a uniqueid to the label
  let resultQueue = dispatch_queue_create("swift.future", DISPATCH_QUEUE_CONCURRENT)

  let execCtx: ExecutionContext // for map
  public init(exec: ExecutionContext) {
    dispatch_suspend(self.resultQueue)
    execCtx = exec
  }
  
  public init(exec: ExecutionContext, _ a: () -> A) {
    dispatch_suspend(self.resultQueue)
    execCtx = exec
    exec.submit(self, work: a)
  }
  
  public init(exec: ExecutionContext, _ a: @auto_closure () -> A) {
    dispatch_suspend(self.resultQueue)
    execCtx = exec
    exec.submit(self, work: a)
  }

  public func sig(x: A) {
    assert(!self.value, "Future cannot complete more than once")
    self.value = x
    dispatch_resume(self.resultQueue)
  }

  public func result() -> A {
    var result : A? = nil
    dispatch_sync(resultQueue, {
      result = self.value!
      })
    return result!
  }

  public func map<B>(f: A -> B) -> Future<B> {
    return Future<B>(exec: execCtx, { f(self.result()) })
  }

  public func flatMap<B>(f: A -> Future<B>) -> Future<B> {
    return Future<B>(exec: execCtx, { f(self.result()).result() })
  }
}
