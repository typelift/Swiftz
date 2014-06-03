//
//  Functor.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

protocol Functor {
    typealias FA
    typealias FB
    func map<A, B>(A -> B) -> FA -> FB
}
