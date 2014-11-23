//
//  HList.swift
//  swiftz
//
//  Created by Maxwell Swadling on 19/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Darwin
import swiftz_core

// A HList can be thought of like a tuple, but with list-like operations on the types.

/* closed */ public protocol HList {
	typealias Head
	typealias Tail // : HList can't show Nothing is in HList, recursive defn.
	class func isNil() -> Bool
	class func makeNil() -> Self
	class func makeCons(h: Head, t: Tail) -> Self
	class func length() -> Int
}

public final class HCons<H, T: HList> : HList {
	public typealias Head = H
	public typealias Tail = T
	public let head: H
	public let tail: T
	public init(h: H, t: T) {
		head = h
		tail = t
	}

	public class func isNil() -> Bool {
		return false
	}
	public class func makeNil() -> HCons<H, T> {
		abort() // impossible
	}
	public class func makeCons(h: Head, t: Tail) -> HCons<H, T> {
		return HCons<H, T>(h: h, t: t)
	}

	public class func length() -> Int {
		return (1 + Tail.length())
	}
}

public final class HNil : HList {
	public typealias Head = Nothing
	public typealias Tail = Nothing

	public init() {}
	public class func isNil() -> Bool {
		return true
	}

	public class func makeNil() -> HNil {
		return HNil()
	}

	public class func makeCons(h: Head, t: Tail) -> HNil {
		abort() // impossible
	}

	public class func length() -> Int {
		return 0
	}
}

// TODO: map and reverse
