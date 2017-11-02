//
//  Copointed.swift
//  Swiftz
//
//  Created by Robert Widmann on 12/12/14.
//  Copyright (c) 2014-2016 Maxwell Swadling. All rights reserved.
//

/// Functors equipped with a copoint that yields a value.
public protocol Copointed {
	associatedtype A
	func extract() -> A
}
