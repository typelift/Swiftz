//
//  Pointed.swift
//  Swiftz
//
//  Created by Robert Widmann on 1/8/15.
//  Copyright (c) 2015-2016 Maxwell Swadling. All rights reserved.
//

/// Functors equipped with a point taking values to instances of themselves.
public protocol Pointed {
	associatedtype A
	static func pure(_ : A) -> Self
}
