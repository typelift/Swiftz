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

class Maybe<A: Any>: F<A> {
	// Hack to get around IR codegen bug
	var value: (() -> A)?

	init(_ v: A) {
		value = { return v }
	}

	init() {}

	class func just(t: A) -> Maybe<A> {
		return Maybe(t)
	}

	class func none() -> Maybe {
		return Maybe()
	}

	func isJust() -> Bool {
		switch value {
			case .Some(_): return true
			case .None: return false
		}
	}

	func isNone() -> Bool {
		return !isJust()
	}

	func fromJust() -> A {
		return self.value!()
	}
}

extension Maybe: LogicValue {
	func getLogicValue() -> Bool {
		return isJust()
	}
}

struct MaybeF<A, B>: Functor {
	let m: Maybe<A>
	func fmap(fn: (A -> B)) -> Maybe<B> {
		if m.isJust() {
			let b: B = fn(m.fromJust())
			return Maybe<B>.just(b);
		} else {
			return Maybe<B>.none()
		}
	}
}

func ==<A: Equatable>(lhs: Maybe<A>, rhs: Maybe<A>) -> Bool {
	if !lhs && !rhs {
		return true
	}

	if lhs && rhs {
		return lhs.fromJust() == rhs.fromJust()
	}

	return false
}
