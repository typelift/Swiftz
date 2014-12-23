//
//  Comonad.swift
//  swiftz_core
//
//  Created by Maxwell Swadling on 29/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

public protocol Comonad : Copointed {
	typealias FFA = K1<Self>

	func duplicate() -> FFA
	func extend(Self -> B) -> FB
}
