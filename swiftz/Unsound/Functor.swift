//
//  Functor.swift
//  swiftz
//
//  Created by Josh Abernathy on 6/7/2014.
//  Copyright (c) 2014 Josh Abernathy. All rights reserved.
//

import Foundation

class F<A> {
}

protocol Functor {
	typealias A
	typealias B
	typealias FB = F<B>
	func fmap(fn: (A -> B)) -> FB
}

