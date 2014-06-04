//
//  GCDExecutionContext.swift
//  swiftz
//
//  Created by Maxwell Swadling on 4/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

let gcdExecutionContext = GCDExecutionContext()
class GCDExecutionContext: ExecutionContext {
  func submit<A>(x: A -> (), y: () -> A) {
    var once = dispatch_once_t()
    dispatch_once(&once, { x(y()) })
  }
}
