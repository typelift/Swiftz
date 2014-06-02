//
//  Applicative.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

protocol Applicative: Functor {
    typealias FB
    typealias FATB
    func pure<A>(A) -> FA
    func apply<A, B>(FATB) -> FA -> FB
}
