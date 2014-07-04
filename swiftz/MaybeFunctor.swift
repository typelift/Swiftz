//
//  Functor.swift
//  swiftz
//
//  Created by Josh Abernathy on 6/7/2014.
//  Copyright (c) 2014 Josh Abernathy. All rights reserved.
//

import Foundation
#if TARGET_OS_MAC
import swiftz_core
#else
import swiftz_core_ios
#endif


class Maybe<A: Any>: F<A> {
	// Hack to get around IR codegen bug
	var value: Box<A>?

	init(_ v: A) {
		value = Box(v)
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
		return self.value!.value
	}
}

extension Maybe: LogicValue {
	func getLogicValue() -> Bool {
		return isJust()
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

struct MaybeF<A, B>: Functor, Applicative {
  // functor
  let m: Maybe<A>
  func fmap(fn: (A -> B)) -> Maybe<B> {
    if m.isJust() {
      let b: B = fn(m.fromJust())
      return Maybe<B>.just(b)
    } else {
      return Maybe<B>.none()
    }
  }
  
  // applicative
  static func pure(a: A) -> Maybe<A>  {
    return Maybe<A>.just(a)
  }
  
  func ap(fn: Maybe<A -> B>) -> Maybe<B>  {
    if fn.isJust() {
      let f: (A -> B) = fn.fromJust()
      return MaybeF(m: m).fmap(f)
    } else {
      return Maybe<B>.none()
    }
  }
}
