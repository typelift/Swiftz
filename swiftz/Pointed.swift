//
//  Pointed.swift
//  swiftz
//
//  Created by Robert Widmann on 1/8/15.
//  Copyright (c) 2015 Maxwell Swadling. All rights reserved.
//

public protocol Pointed {
	typealias A
	class func pure(A) -> Self
}
