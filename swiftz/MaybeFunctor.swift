//
//  Functor.swift
//  swiftz
//
//  Created by Josh Abernathy on 6/7/2014.
//  Copyright (c) 2014 Josh Abernathy. All rights reserved.
//

import Foundation
import swiftz_core

public class Maybe<A: Any>: F<A> {
	var value: A?

	public init(_ v: A) {
		value = v
        super.init()
	}

	public init() {
        super.init()
    }

	public class func just(t: A) -> Maybe<A> {
		return Maybe(t)
	}

	public class func none() -> Maybe {
		return Maybe()
	}

	public func isJust() -> Bool {
		switch value {
			case .Some(_): return true
			case .None: return false
		}
	}

	public func isNone() -> Bool {
		return !isJust()
	}

	public func fromJust() -> A {
		return self.value!
	}
}

extension Maybe: LogicValue {
	public func getLogicValue() -> Bool {
		return isJust()
	}
}

@infix public func ==<A: Equatable>(lhs: Maybe<A>, rhs: Maybe<A>) -> Bool {
	if !lhs && !rhs {
		return true
	}

	if lhs && rhs {
		return lhs.fromJust() == rhs.fromJust()
	}

	return false
}

public struct MaybeF<A, B>: Functor, Applicative {
  // functor
  public let m: Maybe<A>
    
  public init(_ m: Maybe<A>) {
    self.m = m
  }
  public func fmap(f: (A -> B)) -> Maybe<B> {
    if m.isJust() {
      let b: B = f(m.fromJust())
      return Maybe<B>.just(b)
    } else {
      return Maybe<B>.none()
    }
  }
  
  // applicative
  public static func pure(a: A) -> Maybe<A>  {
    return Maybe<A>.just(a)
  }
  
  public func ap(fn: Maybe<A -> B>) -> Maybe<B>  {
    if fn.isJust() {
      let f: (A -> B) = fn.fromJust()
      return MaybeF(m).fmap(f)
    } else {
      return Maybe<B>.none()
    }
  }
}
