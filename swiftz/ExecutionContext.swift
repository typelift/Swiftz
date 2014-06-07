//
//  ExecutionContext.swift
//  swiftz
//
//  Created by Maxwell Swadling on 7/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

// Implement this protocol to be an execution context.
// for example, a lightweight threading runtime...
protocol ExecutionContext {
  func submit<A>(x: Future<A>, work: () -> A)
}
