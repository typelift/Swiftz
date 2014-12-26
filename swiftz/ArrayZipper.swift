//
//  ArrayZipper.swift
//  swiftz
//
//  Created by Alexander Ronald Altman on 8/4/14.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

/// A cursor for arrays.
public struct ArrayZipper<A> : ArrayLiteralConvertible {
	typealias Element = A

	public let values: [A]
	public let position: Int

	public init(_ values: [A] = [], _ position: Int = 0) {
		if position < 0 {
			self.position = 0
		} else if position >= values.count {
			self.position = values.count - 1
		} else {
			self.position = position
		}
		self.values = values
	}

	public init(arrayLiteral elements: Element...) {
		self.init(elements, 0)
	}

	public func map<B>(f: A -> B) -> ArrayZipper<B> {
		return f <^> self
	}

	public func dup() -> ArrayZipper<ArrayZipper<A>> {
		return duplicate(self)
	}

	public func extend<B>(f: ArrayZipper<A> -> B) -> ArrayZipper<B> {
		return self ->> f
	}

	public func move(n: Int = 1) -> ArrayZipper<A> {
		return ArrayZipper(values, position + n)
	}

	public func moveTo(pos: Int) -> ArrayZipper<A> {
		return ArrayZipper(values, pos)
	}
}

public func extract<A>(xz: ArrayZipper<A>) -> A {
	return xz.values[xz.position]
}

public func <^><A, B>(f: A -> B, xz: ArrayZipper<A>) -> ArrayZipper<B> {
	return ArrayZipper(f <^> xz.values, xz.position)
}

public func duplicate<A>(xz: ArrayZipper<A>) -> ArrayZipper<ArrayZipper<A>> {
	return ArrayZipper((0 ..< xz.values.count).map { ArrayZipper(xz.values, $0) }, xz.position)
}

public func ->><A, B>(xz: ArrayZipper<A>, f: ArrayZipper<A> -> B) -> ArrayZipper<B> {
	return ArrayZipper((0 ..< xz.values.count).map { f(ArrayZipper(xz.values, $0)) }, xz.position)
}
