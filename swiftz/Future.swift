//
//  Future.swift
//  swiftz
//
//  Created by Maxwell Swadling on 4/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation
#if TARGET_OS_MAC
import swiftz_core
#else
import swiftz_core_ios
#endif

class Future<A> {
  // FIXME: Closure indirection here to work around unimplemented Swift feature.
  // If this is A?, then clang complains "error: unimplemented IR generation feature non-fixed class layout"
  var value: Optional<Box<A>>

  // The resultQueue is used to read the result. It begins suspended
  // and is resumed once a result exists.
  // FIXME: Would like to add a uniqueid to the label
  let resultQueue = dispatch_queue_create("swift.future", DISPATCH_QUEUE_CONCURRENT)

  let execCtx: ExecutionContext // for map

  init(exec: ExecutionContext, a: () -> A) {
    dispatch_suspend(resultQueue)

    execCtx = exec
    exec.submit(self, work: a)
  }

  func sig(x: A) {
    assert(!self.value, "Future cannot complete more than once")
    self.value = Box(x)
    dispatch_resume(self.resultQueue)
  }

  func result() -> A {
    var result : A? = nil
    dispatch_sync(resultQueue, {
      result = self.value!.value
      })
    return result!
  }

  func map<B>(f: A -> B) -> Future<B> {
    return Future<B>(exec: execCtx, { f(self.result()) })
  }

  func flatMap<B>(f: A -> Future<B>) -> Future<B> {
    return Future<B>(exec: execCtx, { f(self.result()).result() })
  }
}
