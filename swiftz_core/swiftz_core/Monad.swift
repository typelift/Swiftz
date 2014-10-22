//
//  Monad.swift
//  swiftz_core
//
//  Created by Maxwell Swadling on 29/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

public protocol Monad : Applicative {
  typealias AFB = A -> K1<B>
  func bind(f: AFB) -> FB
}
