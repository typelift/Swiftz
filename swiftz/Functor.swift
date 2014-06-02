//
//  Functor.swift
//  swiftz
//
//  Created by Maxwell Swadling on 3/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Foundation

protocol Functor {
    typealias FA
    func map<A, B>(A -> B) -> FA -> B
}
