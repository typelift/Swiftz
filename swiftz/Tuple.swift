//
//  Tuple.swift
//  swiftz
//
//  Created by Maxwell Swadling on 19/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

// A tuple you can use in type parameters
public struct Tuple2<A, B> {
	public let a: A
	public let b: B

	public init(a: A, b: B) {
		self.a = a
		self.b = b
	}
}
