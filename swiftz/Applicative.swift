//
//  Applicative.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

protocol Applicative: Functor {
    typealias FATB // F (A -> B)
    func pure(A) -> FA
    func apply(FATB) -> FA -> FB
}
