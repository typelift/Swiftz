//
//  Functor.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

protocol Functor {
    typealias A
    typealias B
    typealias FA // F A
    typealias FB // F B
    func map(A -> B) -> FA -> FB
}
